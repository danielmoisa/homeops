# picluster-local

A single-node K3S homelab cluster for local testing on Ubuntu x86, based on
[PiCluster](https://picluster.ricsanfre.com) but simplified for a laptop/desktop setup.

**Key differences from the original:**
- Single-node K3S (no multi-node, no Kube-VIP)
- ArgoCD instead of FluxCD for GitOps
- Helm-based deployments throughout
- `local-path` storage instead of Longhorn
- No Istio, no Kafka (can be added later)
- No cloud-init / PXE (direct K3S install)

## Stack

| Category        | Tool                        |
|-----------------|-----------------------------|
| Kubernetes      | K3S                         |
| GitOps          | ArgoCD                      |
| Certificates    | Cert-Manager (self-signed)  |
| Secrets         | Vault (dev mode)            |
| Object Storage  | Minio                       |
| Monitoring      | Prometheus + Grafana        |
| Logging         | Loki + Grafana              |
| IAM             | Keycloak                    |
| Backup          | Velero + Restic             |

## Requirements

- Ubuntu 22.04+ / 24.04
- 8GB RAM minimum (16GB recommended)
- ~20GB free disk
- `kubectl`, `helm`, `argocd` CLI installed

## Quick Start

```bash
# 1. Install K3S
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -

# 2. Set up kubeconfig
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config

# 3. Install ArgoCD
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd -f argocd/values.yaml

# 4. Wait for ArgoCD to be ready
kubectl -n argocd rollout status deploy/argocd-server

# 5. Apply the root App-of-Apps
kubectl apply -f bootstrap/root-app.yaml
```

## Directory Structure

```
.
├── bootstrap/          # ArgoCD root App-of-Apps
├── argocd/             # ArgoCD Helm values
├── apps/               # ArgoCD Application manifests
│   ├── base/           # App definitions
│   └── overlays/local/ # Local environment overrides
└── infrastructure/     # Helm values per service
    ├── cert-manager/
    ├── vault/
    ├── minio/
    ├── prometheus/
    ├── loki/
    └── keycloak/
```
