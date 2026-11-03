#!/bin/bash
set -Eeuo pipefail

ENV="${1:?Uso: deploy-env.sh staging|production}"

case "$ENV" in
  staging)
    RELEASE=notes-staging
    NS=staging
    VALUES=devops-portfolio/values-staging.yaml
    ;;
  production)
    RELEASE=notes-prod
    NS=production
    VALUES=devops-portfolio/values-prod.yaml
    ;;
  *)
    echo "Entorno invalido"
    exit 1
    ;;
esac

: "${DB_PASSWORD:?Falta DB_PASSWORD}"
: "${GHCR_READ_TOKEN:?Falta GHCR_READ_TOKEN}"
: "${GHCR_USERNAME:?Falta GHCR_USERNAME}"
: "${BACKEND_IMAGE:?Falta BACKEND_IMAGE}"
: "${FRONTEND_IMAGE:?Falta FRONTEND_IMAGE}"
: "${IMAGE_TAG:?Falta IMAGE_TAG}"

TEMP_DIR=$(mktemp -d)
chmod 700 "$TEMP_DIR"
trap 'rm -rf "$TEMP_DIR"' EXIT

echo "=== PREPARAR NAMESPACE ==="
kubectl create namespace "$NS" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "=== PREPARAR CREDENCIALES GHCR ==="

export GHCR_USERNAME GHCR_READ_TOKEN

python3 - "$TEMP_DIR/config.json" <<'PY'
import os
import sys
import json
import base64

user = os.environ["GHCR_USERNAME"]
token = os.environ["GHCR_READ_TOKEN"]

auth = base64.b64encode(
    f"{user}:{token}".encode()
).decode()

with open(sys.argv[1], "w") as f:
    json.dump({"auths": {
        "ghcr.io": {
            "username": user,
            "password": token,
            "auth": auth
        }
    }}, f)
PY

unset GHCR_READ_TOKEN

kubectl create secret generic ghcr-creds \
  -n "$NS" \
  --from-file=.dockerconfigjson="$TEMP_DIR/config.json" \
  --type=kubernetes.io/dockerconfigjson \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl patch serviceaccount default \
  -n "$NS" \
  --type=merge \
  -p='{"imagePullSecrets":[{"name":"ghcr-creds"}]}'

echo "=== GUARDAR CONTRASEÑA ==="
printf '%s' "$DB_PASSWORD" > "$TEMP_DIR/db-password"
unset DB_PASSWORD

echo "=== RECORDAR REVISION ANTERIOR ==="
PREVIOUS=$(
  helm history "$RELEASE" -n "$NS" 2>/dev/null |
  awk 'NR>1 && $3=="deployed" {r=$1} END {print r}' || true
)

echo "=== DESPLEGAR CON HELM ==="

helm upgrade --install "$RELEASE" ./devops-portfolio \
  --namespace "$NS" \
  --create-namespace \
  -f "$VALUES" \
  --set-string backend.image.repository="$BACKEND_IMAGE" \
  --set-string backend.image.tag="$IMAGE_TAG" \
  --set-string frontend.image.repository="$FRONTEND_IMAGE" \
  --set-string frontend.image.tag="$IMAGE_TAG" \
  --set-file postgres.credentials.password="$TEMP_DIR/db-password" \
  --atomic \
  --wait --timeout 300s

echo "=== SMOKE TEST ==="

if scripts/smoke-test.sh "$ENV"; then
    echo "[PASS] Despliegue y pruebas aprobados."
else
    echo "[FAIL] Smoke Test fallido. Recuperando revision anterior."

    if [[ -n "$PREVIOUS" ]]; then
        helm rollback "$RELEASE" "$PREVIOUS" \
          -n "$NS" --wait --timeout 300s
    else
        helm uninstall "$RELEASE" -n "$NS"
    fi

    exit 1
fi

echo "=== ESTADO FINAL ==="
helm status "$RELEASE" -n "$NS"
