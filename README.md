# homeops

Personal Kubernetes homelab running on k3d (single Ubuntu node).
GitOps managed with ArgoCD, all apps deployed via Helm.

## Architecture

```
┌─ GitOps ──────────────────────────────────────────────┐
│  ArgoCD                                                │
├─ Kubernetes ──────────────────────────────────────────┤
│  K3D (K3S in Docker)                                   │
├─ Infrastructure ──────────────────────────────────────┤
│  ingress-nginx  │  cert-manager  │  vault  │  minio   │
│  external-secrets-operator                             │
├─ Auth ────────────────────────────────────────────────┤
│  Keycloak                                              │
├─ Observability ───────────────────────────────────────┤
│  Prometheus  │  Grafana  │  Loki  │  Fluentbit         │
├─ Backup ──────────────────────────────────────────────┤
│  Velero + Restic → Minio (S3)                          │
└───────────────────────────────────────────────────────┘
```

## What can be added on a multi-cluster

| Component      | Reason                                       |
|----------------|----------------------------------------------|
| Longhorn       | Needs multi-node — using local-path instead  |
| Kube-VIP       | No bare metal LB needed on k3d               |
| Envoy Gateway  | Using ingress-nginx (simpler)                |
| External DNS   | No real DNS needed locally                   |
| Istio          | Too heavy for single node                    |
| Kafka          | Not needed for local testing                 |
| Elasticsearch  | Too heavy — Loki covers logging              |
| Kibana         | Grafana covers dashboards                    |
| Fluentd        | Fluentbit is enough for single node          |
| Tempo          | Skipped per user preference                  |
| CloudNative-PG | Not needed yet                               |
| MongoDB        | Not needed yet                               |
| Ansible        | k3d replaces bare metal node configuration   |
| OpenTofu       | Everything runs in-cluster, nothing external |

## Repo Structure

```
homeops/
├── bootstrap/
│   ├── install-argocd.sh     # Run once to install ArgoCD
│   └── root-app.yaml         # Run once to bootstrap everything else
├── argocd/
│   └── values.yaml           # ArgoCD Helm values
├── apps/
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
└── docs/
    └── port-forwards.md
```

## Quick Start

```bash
# 1. Install k3d
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# 2. Create cluster
k3d cluster create homeops \
  --agents 1 \
  --k3s-arg "--disable=traefik@server:0" \
  --port "80:80@loadbalancer" \
  --port "443:443@loadbalancer"

# 3. Bootstrap ArgoCD
chmod +x bootstrap/install-argocd.sh
./bootstrap/install-argocd.sh

# 4. Apply root app
kubectl apply -f bootstrap/root-app.yaml
```

## Accessing Services

See [docs/port-forwards.md](docs/port-forwards.md)
