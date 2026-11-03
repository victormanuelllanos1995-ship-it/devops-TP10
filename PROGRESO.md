# TP 10 - DevOps Portfolio

## Estado: IMPLEMENTACION COMPLETADA

### Infraestructura
- Kubernetes con controlplane y node01.
- Helm v4.3.0.
- Docker disponible.
- StorageClass local-path.
- Traefik instalado mediante Helm.
- IngressClass traefik.
- NodePort 30080.

### Aplicacion
- Frontend desplegado.
- Backend Flask desplegado.
- PostgreSQL desplegado.
- PVC de PostgreSQL: Bound.
- Tres replicas de backend configuradas en revision 2.
- Inicializacion automatica de tabla notes.

### Helm
- helm lint: aprobado.
- helm template: ejecutado.
- helm install/upgrade: completado.
- helm status: deployed.
- helm history: revisiones 1, 2 y 3.
- helm rollback mi-app 1: completado.
- Revision final: 3 (deployed).

### Verificaciones
- Frontend: HTTP 200.
- Backend /health: HTTP 200.
- API /api/notes: HTTP 200.
- Script verificar.sh corregido.
- Verificacion TP 10: OK antes del rollback.

### Repositorio
https://github.com/victormanuelllanos1995-ship-it/devops-TP10
