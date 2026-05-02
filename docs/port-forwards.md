# Accessing Services

## /etc/hosts

Add these entries so the ingress hostnames resolve locally:

```
127.0.0.1  grafana.local
127.0.0.1  prometheus.local
127.0.0.1  vault.local
127.0.0.1  minio.local
127.0.0.1  minio-console.local
127.0.0.1  keycloak.local
```

## Service URLs (via ingress-nginx on port 80)

| Service       | URL                        | User       | Password   |
|---------------|----------------------------|------------|------------|
| Grafana       | http://grafana.local       | admin      | admin      |
| Prometheus    | http://prometheus.local    | -          | -          |
| Vault         | http://vault.local         | -          | root       |
| Minio API     | http://minio.local         | minioadmin | minioadmin |
| Minio Console | http://minio-console.local | minioadmin | minioadmin |
| Keycloak      | http://keycloak.local      | admin      | admin      |

## ArgoCD (port-forward only)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
# http://localhost:8080
# Password:
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

## Fallback port-forwards (if ingress not working)

```bash
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090
kubectl port-forward svc/vault -n vault 8200:8200
kubectl port-forward svc/minio-console -n minio 9001:9001
kubectl port-forward svc/keycloak -n keycloak 8088:80
```
