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

## TP10B - Validaciones completadas
- Helm lint DEV y PROD.
- Renderizado DEV y PROD.
- Python YAML: 11 objetos válidos por entorno.
- yamllint sin errores.
- Checksums SHA256 de ConfigMap y Secret.
- kubectl dry-run DEV y PROD.
- scripts/render-validate.sh ejecutado correctamente.

## TP10C - Configuración inicial

- values-staging.yaml creado.
- values-prod.yaml creado.
- Helm lint aprobado en ambos entornos.
- Renderizado de Staging y Producción aprobado.
- HPA desactivado en Staging.
- HPA de Producción configurado: mínimo 3, máximo 6, CPU 70%.
- Plantilla hpa.yaml creada.
- Script verificar-helm-entornos.sh creado.
- Pendiente: Metrics Server, despliegues y pipeline CD.

## TP10C - Avance adicional
- Traefik instalado mediante Helm.
- Namespace: traefik.
- Pod: 1/1 Running.
- Service NodePort HTTP: 30080.
- IngressClass: traefik.
- Metrics Server: pendiente.
- Despliegues Staging y Producción: pendientes.
- Pipeline helm-cd.yml: pendiente.

## TP10C - Infraestructura preparada

- Backend 1.0.0 construido e importado en controlplane y node01.
- Frontend 1.0.1 construido e importado en controlplane y node01.
- Traefik instalado mediante Helm.
- Traefik NodePort HTTP: 30080.
- Metrics Server instalado.
- API metrics.k8s.io: Available=True.
- Métricas de CPU y memoria disponibles en ambos nodos.
- TLS insecure configurado exclusivamente para Killercoda.
- Pendiente: despliegue Staging, Smoke Tests y Producción.

## TP10C - STAGING: SMOKE TEST APROBADO

- Release Helm: notes-staging.
- Namespace: staging.
- Revision Helm: 3.
- Backend: 1/1 Running.
- Frontend: 1/1 Running.
- PostgreSQL: 1/1 Running.
- Frontend Nginx corregido: backend-service:5000.
- Nueva imagen frontend: 1.0.2.
- Smoke Test Frontend: HTTP 200.
- Smoke Test Backend /health: HTTP 200.
- Smoke Test API /api/notes: HTTP 200.
- Pruebas realizadas mediante kubectl port-forward.
- Pendiente: Traefik, Producción, HPA y pipeline CD.

## TP10C - Correccion Frontend

- Nginx corregido: backend-service:5000.
- Frontend actualizado a version 1.0.2.
- Imagen devops-portfolio-frontend:1.0.2 construida.
- values-staging.yaml actualizado.
- values-prod.yaml actualizado.
- Helm lint Staging: aprobado.
- Helm lint Produccion: aprobado.
- Pendiente: publicar imagen en GHCR y desplegar Produccion.

## TP10C - Imagenes publicadas en GHCR

- Backend 1.0.0 publicado correctamente.
- Frontend 1.0.2 publicado correctamente.
- Registro: ghcr.io/victormanuelllanos1995-ship-it.
- Docker login GHCR: exitoso.
- Docker push Backend: exitoso.
- Docker push Frontend: exitoso.
- Credenciales GHCR cerradas y eliminadas de la configuracion temporal.
- Pendiente: desplegar Produccion con imagenes GHCR.
- Pendiente: comprobar HPA y automatizacion CD.

## TP10C - GHCR y Produccion recuperados

- Autenticacion GHCR con token classic: exitosa.
- Backend 1.0.0 descargable desde GHCR.
- Frontend 1.0.2 descargable desde GHCR.
- Secret ghcr-creds configurado en staging y production.
- ServiceAccount default asociado a ghcr-creds.
- Contraseña interna PostgreSQL sincronizada con Kubernetes Secret.
- PVC PostgreSQL de Produccion: 5Gi Bound.
- Backend Produccion: 3/3 Running.
- Frontend Produccion: 2/2 Running.
- PostgreSQL Produccion: 1/1 Running.
- Metrics Server operativo.
- HPA backend: CPU 11%, objetivo 70%, minimo 3 y maximo 6.
- Pendiente: Smoke Test Produccion y confirmar estado final Helm.
- Pendiente: GitHub Actions, aprobacion manual y rollback.

## TP10C - Produccion validada

- GHCR configurado con imagePullSecret.
- Backend y Frontend descargados desde GHCR.
- PostgreSQL conectado y autenticacion corregida.
- Backend: 3/3 Running.
- Frontend: 2/2 Running.
- PostgreSQL: 1/1 Running.
- PVC: Bound, 5Gi.
- Smoke Test Frontend: HTTP 200.
- Smoke Test Backend: HTTP 200.
- Smoke Test API Notes: HTTP 200.
- Metrics Server operativo.
- HPA: CPU 2%/70%, minimo 3, maximo 6.
- Pendiente: prueba de escalado bajo carga.
- Pendiente: GitHub Actions, aprobacion manual y rollback.

## TP10C - Automatizacion CI/CD

- scripts/smoke-test.sh creado.
- scripts/deploy-env.sh creado.
- Smoke Tests reutilizables.
- Helm upgrade con atomic y wait.
- Rollback ante fallo del Smoke Test.
- Workflow helm-cd.yml creado.
- Build y publicacion GHCR automatizados.
- Validacion Helm Staging y Produccion automatizada.
- Deploy Staging preparado.
- Deploy Produccion con environment protegido preparado.
- Pendiente: configurar GitHub Environments.
- Pendiente: runner self-hosted con acceso al cluster.
- Pendiente: ejecutar Actions y comprobar rollback.
