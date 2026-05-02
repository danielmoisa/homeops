# homeops

Personal Kubernetes homelab on k3d. GitOps with ArgoCD, everything deployed via Helm.

## Stack

| Category        | Tool                                      |
|-----------------|-------------------------------------------|
| Kubernetes      | K3D (K3S in Docker)                       |
| GitOps          | ArgoCD                                    |
| Ingress         | ingress-nginx                             |
| Certificates    | cert-manager (self-signed)                |
| Secrets         | Vault (dev mode) + External Secrets       |
| Storage         | Minio (S3) + local-path (PVC)             |
| Auth            | Keycloak                                  |
| Metrics         | Prometheus + Grafana                      |
| Logs            | Loki + Fluentbit                          |
| Backup          | Velero + Restic → Minio                   |

## Structure

```
homeops/
├── bootstrap/
│   ├── install-argocd.sh     # Run once
│   └── root-app.yaml         # Apply once
├── argocd/
│   └── values.yaml
├── apps/                     # Only ArgoCD Application manifests
│   ├── infrastructure/
│   │   ├── ingress-nginx.yaml
│   │   ├── cert-manager.yaml
│   │   ├── cert-issuer.yaml
│   │   ├── vault.yaml
│   │   ├── external-secrets.yaml
│   │   └── minio.yaml
│   ├── auth/
│   │   └── keycloak.yaml
│   ├── observability/
│   │   ├── prometheus.yaml
│   │   ├── loki.yaml
│   │   └── fluentbit.yaml
│   └── backup/
│       └── velero.yaml
├── manifests/                # Raw Kubernetes manifests (not ArgoCD apps)
│   └── cert-issuer/
│       └── cluster-issuer.yaml
└── docs/
    └── port-forwards.md
```

## Quick Start

```bash
# 1. Create k3d cluster
k3d cluster create homeops \
  --agents 1 \
  --k3s-arg "--disable=traefik@server:0" \
  --port "80:80@loadbalancer" \
  --port "443:443@loadbalancer"

# 2. Install ArgoCD
chmod +x bootstrap/install-argocd.sh
./bootstrap/install-argocd.sh

# 3. Bootstrap everything
kubectl apply -f bootstrap/root-app.yaml
```

See [docs/port-forwards.md](docs/port-forwards.md) for accessing services.
