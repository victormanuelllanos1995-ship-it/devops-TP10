#!/bin/bash
set -euo pipefail

CHART="./devops-portfolio"
echo "=========================================="
echo " TP10B - RENDER FIRST, VALIDATE SECOND"
echo "=========================================="

echo ""
echo "=== 1. HELM LINT ==="
helm lint "$CHART" -f values-dev.yaml
helm lint "$CHART" -f values-prod.yaml

echo ""
echo "=== 2. RENDERIZADO ==="
helm template mi-app "$CHART" -f values-dev.yaml \
  > manifests-rendered-dev.yaml

helm template mi-app "$CHART" -f values-prod.yaml \
  > manifests-rendered-prod.yaml

echo "[OK] DEV y PROD renderizados"

echo ""
echo "=== 3. VALIDACION PYTHON YAML ==="
python3 - <<'PY'
import yaml

for filename in [
    "manifests-rendered-dev.yaml",
    "manifests-rendered-prod.yaml"
]:
    with open(filename) as stream:
        docs = [doc for doc in yaml.safe_load_all(stream) if doc]

    print(f"[OK] {filename}: {len(docs)} objetos válidos")
    for doc in docs:
        print(f"  - {doc['kind']} -> {doc['metadata']['name']}")
PY

echo ""
echo "=== 4. VALIDACION YAMLLINT ==="
yamllint -d "{extends: default, rules: {line-length: {max: 120}, document-start: disable}}" \
  manifests-rendered-dev.yaml manifests-rendered-prod.yaml

echo "[OK] Sintaxis YAML correcta"

echo ""
echo "=== 5. VALIDACION CHECKSUMS ==="
for file in manifests-rendered-dev.yaml manifests-rendered-prod.yaml; do
  grep -q 'checksum/config:' "$file"
  grep -q 'checksum/secret:' "$file"
  echo "[OK] Checksums presentes en $file"
done

echo ""
echo "=== 6. KUBERNETES DRY-RUN ==="
kubectl apply --dry-run=client -f manifests-rendered-dev.yaml
kubectl apply --dry-run=client -f manifests-rendered-prod.yaml

echo ""
echo "=========================================="
echo " TP10B OK: TODAS LAS VALIDACIONES PASARON"
echo "=========================================="
