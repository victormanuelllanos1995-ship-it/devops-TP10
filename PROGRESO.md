# PROGRESO TP10

## Completado
- Proyecto recuperado y publicado en GitHub.
- Chart Helm validado: helm lint correcto.
- Kubernetes: controlplane y node01 Ready.
- Helm v4.3.0.
- Docker 29.1.3.
- Traefik instalado.
- IngressClass traefik.
- NodePort 30080.
- Imagen backend 1.0.0 construida e importada en ambos nodos.
- Imagen frontend 1.0.1 construida e importada en ambos nodos.

## Pendiente
1. Ejecutar helm template.
2. Instalar mi-app con Helm.
3. Verificar PostgreSQL.
4. Verificar frontend y backend.
5. Verificar Ingress.
6. Ejecutar scripts/verificar.sh.
7. Guardar evidencias.

## Repositorio
https://github.com/victormanuelllanos1995-ship-it/devops-TP10

## Comandos para reconstruir las imágenes

docker build -t devops-portfolio-backend:1.0.0 ./backend
docker build -t devops-portfolio-frontend:1.0.1 ./frontend

ctr -n k8s.io images import /tmp/backend.tar
ctr -n k8s.io images import /tmp/frontend.tar

## Próximo paso
helm template mi-app ./devops-portfolio -f values-dev.yaml -n devops-portfolio
