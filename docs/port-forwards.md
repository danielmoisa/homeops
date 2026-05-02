# Port Forwards

Quick reference for accessing all services locally.
Add these to `/etc/hosts` for nicer URLs:

```
127.0.0.1  argocd.local
127.0.0.1  grafana.local
127.0.0.1  prometheus.local
127.0.0.1  vault.local
127.0.0.1  minio.local
127.0.0.1  minio-console.local
127.0.0.1  keycloak.local
```

Once ingress-nginx is running, all services are available via port 80
(mapped from k3d `--port "80:80@loadbalancer"`).

| Service         | URL                          | User      | Password   |
|-----------------|------------------------------|-----------|------------|
| ArgoCD          | http://localhost:8080        | admin     | (see below)|
| Grafana         | http://grafana.local         | admin     | admin      |
| Prometheus      | http://prometheus.local      | -         | -          |
| Vault           | http://vault.local           | -         | root       |
| Minio Console   | http://minio-console.local   | minioadmin| minioadmin |
| Keycloak        | http://keycloak.local        | admin     | admin      |

## ArgoCD (port-forward only — no ingress for security)

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:80
```

Get admin password:
```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

## If ingress is not working yet (fallback port-forwards)

```bash
# Grafana
kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80

# Prometheus
kubectl port-forward svc/prometheus-kube-prometheus-prometheus -n monitoring 9090:9090

# Vault
kubectl port-forward svc/vault -n vault 8200:8200

# Minio console
kubectl port-forward svc/minio-console -n minio 9001:9001

# Keycloak
kubectl port-forward svc/keycloak -n keycloak 8088:80
```
