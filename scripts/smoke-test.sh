#!/bin/bash
set -Eeuo pipefail

ENV="${1:?Uso: smoke-test.sh staging|production}"

case "$ENV" in
  staging)
    NS=staging
    FRONT_PORT=18080
    BACK_PORT=15000
    ;;
  production)
    NS=production
    FRONT_PORT=28080
    BACK_PORT=25000
    ;;
  *)
    echo "Entorno invalido"
    exit 1
    ;;
esac

echo "=== SMOKE TEST $ENV ==="

kubectl rollout status deployment/backend -n "$NS" --timeout=180s
kubectl rollout status deployment/frontend -n "$NS" --timeout=180s
kubectl rollout status deployment/postgres -n "$NS" --timeout=180s

kubectl port-forward -n "$NS" \
  svc/frontend-service "$FRONT_PORT":80 \
  >/tmp/front-forward.log 2>&1 &
PF_FRONT=$!

kubectl port-forward -n "$NS" \
  svc/backend-service "$BACK_PORT":5000 \
  >/tmp/back-forward.log 2>&1 &
PF_BACK=$!

cleanup() {
  kill "$PF_FRONT" "$PF_BACK" 2>/dev/null || true
}
trap cleanup EXIT

sleep 3

check_http() {
  local name="$1"
  local url="$2"
  local body
  local code

  body=$(mktemp)
  code=$(curl -sS -o "$body" -w '%{http_code}' \
    --max-time 15 "$url" 2>/dev/null) || code=000

  echo "$name: HTTP $code"

  if [[ "$code" != "200" ]]; then
    cat "$body"
    rm -f "$body"
    return 1
  fi

  cat "$body"
  rm -f "$body"
}

check_http "Frontend" "http://127.0.0.1:$FRONT_PORT/"
check_http "Backend health" "http://127.0.0.1:$BACK_PORT/health"
check_http "API notes" "http://127.0.0.1:$FRONT_PORT/api/notes"

echo "=== SMOKE TEST APROBADO ==="
