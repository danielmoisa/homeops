# 🏠 homelab-gitops

<div style="display: flex; justify-content: left; flex-direction: row; align-items: center;">
<div><p>My Kubernetes cluster managed with ArgoCD.</p><p>
<img alt="Health" src="https://status.terence.cloud/api/v1/endpoints/_homelab/health/badge.svg">
<img alt="Uptime" src="https://status.terence.cloud/api/v1/endpoints/_homelab/uptimes/7d/badge.svg">
</p></div>
</div>

## ⚙️ Hardware

| Device                    | Name     | Specs                                                                 | OS    | Role                       |
|---------------------------|----------|-----------------------------------------------------------------------|-------|----------------------------|
| Lenovo ThinkCentre M75q-2 | homelab2 | Ryzen 5 Pro 5650GE (6 core / 12 threads) / 24GB RAM / 256GB + 2TB SSD | NixOS | k8s controller+worker node |

## ✨ Features

- Kubernetes cluster deployed with [k0s](https://k0sproject.io/)
- GitOps deployment with [ArgoCD](https://argo-cd.readthedocs.io/en/stable/) and [Helm](https://helm.sh/)
- Simple flat directory structure: [argocd-apps](/argocd-apps/) contains ArgoCD applications deploying umbrella Helm charts in [k8s-apps](/k8s-apps/)
- Fully automated HTTPS exposition using [cert-manager](https://cert-manager.io/), [external-dns](https://kubernetes-sigs.github.io/external-dns) and [traefik](https://doc.traefik.io/traefik/)
- Authentication of sensitive apps with [PocketID](https://pocket-id.org/) as a passkey-only OIDC provider
- WAF using [ModSecurity plugin](https://plugins.traefik.io/plugins/644d9a72ebafd55c9c740848/mx-m-owasp-crs-modsecurity-plugin) and some [hacks](https://github.com/danielmoisa/homeops/blob/a3fc90f9bab0287c901fd8f3cbab295a695b7658/k8s-apps/traefik/values.yaml#L78)
- Secrets management with [external-secrets](https://external-secrets.io/latest/), [OpenBao](https://openbao.org/) and [sops](https://github.com/getsops/sops) (check [terraform](/terraform/secrets/) for provisioning method)
- Offsite data backup using [Velero](https://velero.io/) and [Backblaze B2](https://www.backblaze.com/cloud-storage)
- Easy Backblaze-to-disk backup synchronization with [Kopia](https://kopia.io/)
- PostgreSQL database management with [CloudNativePG](https://cloudnative-pg.io/)
- Observability with [Prometheus](https://prometheus.io/), [Grafana](https://grafana.com/), [Loki](https://grafana.com/oss/loki/) and [Opentelemetry Collector](https://opentelemetry.io/docs/collector/)
- Alerting with [Alertmanager](https://prometheus.io/docs/alerting/latest/alertmanager/) and a [Telegram Bot](https://prometheus.io/docs/alerting/latest/configuration/#telegram_config)
- Thorough HTTP / PostgreSQL status checks with [go-healthcheck](https://github.com/danielmoisa/go-healthcheck) and [Gatus](https://gatus.io/)
- Automated updates with [Renovate](https://docs.renovatebot.com/) ([even linuxserver images!](/renovate.json5))
- Scale to zero using [Sablier](https://sablierapp.dev)
- Any app you'd want to host: [Nextcloud](https://nextcloud.com/fr/), [Immich](https://immich.app/), [Paperless-ngx](https://docs.paperless-ngx.com/) and more (see below)

## 💻 What's currently deployed in my cluster ?

This is an [automatically updated](.github/workflows/update-deployed-apps.yaml) list of the apps I have configured and/or deployed. Click on an app to check its Helm configuration.

<!-- BEGIN deployed-apps -->
| App | Description | Is deployed |
| --- | --- | --- |
| [anki-sync-server](./scripts/../k8s-apps/anki-sync-server) | Sync server for AnkiDroid | ❌ |
| [anubis](./scripts/../k8s-apps/anubis) | Weighs the soul of incoming HTTP requests to stop AI crawlers | ✅ |
| [argocd](./scripts/../k8s-apps/argocd) | Declarative, GitOps continuous delivery tool for Kubernetes | ✅ |
| [arr-stack](./scripts/../k8s-apps/arr-stack) | Arr Stack | ✅ |
| [attic](./scripts/../k8s-apps/attic) | Multi-tenant Nix Binary Cache | ❌ |
| [audiobookshelf](./scripts/../k8s-apps/audiobookshelf) | Self-hosted audiobook and podcast server | ✅ |
| [blackbox-exporter](./scripts/../k8s-apps/blackbox-exporter) | Allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC | ❌ |
| [calibre-web](./scripts/../k8s-apps/calibre-web) | Web app for browsing, reading and downloading eBooks stored in a Calibre database | ❌ |
| [cert-manager](./scripts/../k8s-apps/cert-manager) | Automatically provision and manage TLS certificates in Kubernetes | ✅ |
| [changedetection](./scripts/../k8s-apps/changedetection) | Website change detection, web page monitoring, and website change alerts | ✅ |
| [cloudnative-pg](./scripts/../k8s-apps/cloudnative-pg) | CloudNativePG is a comprehensive platform designed to seamlessly manage PostgreSQL databases within Kubernetes environments, covering the entire operational lifecycle from initial deployment to ongoing maintenance | ✅ |
| [convertx](./scripts/../k8s-apps/convertx) | Self-hosted online file converter | ✅ |
| [external-dns](./scripts/../k8s-apps/external-dns) | Configure external DNS servers (AWS Route53, Google CloudDNS and others) for Kubernetes Ingresses and Services | ✅ |
| [external-secrets](./scripts/../k8s-apps/external-secrets) | External Secrets Operator reads information from a third-party service like AWS Secrets Manager and automatically injects the values as Kubernetes Secrets | ✅ |
| [falco](./scripts/../k8s-apps/falco) | Cloud Native Runtime Security | ❌ |
| [gitea](./scripts/../k8s-apps/gitea) | Self-hosted Git service with a lightweight code hosting solution written in Go | ✅ |
| [go-healthcheck](./scripts/../k8s-apps/go-healthcheck) | Simple HTTP healthchecks | ✅ |
| [home-assistant](./scripts/../k8s-apps/home-assistant) | Open source home automation that puts local control and privacy first | ✅ |
| [homepage](./scripts/../k8s-apps/homepage) | A highly customizable homepage (or startpage / application dashboard) with Docker and service API integrations | ❌ |
| [httpbin](./scripts/../k8s-apps/httpbin) | Echoes request data as JSON | ✅ |
| [immich](./scripts/../k8s-apps/immich) | High performance self-hosted photo and video management solution | ✅ |
| [it-tools](./scripts/../k8s-apps/it-tools) | Collection of handy online tools for developers | ✅ |
| [kube-prometheus-stack](./scripts/../k8s-apps/kube-prometheus-stack) | kube-prometheus-stack collects Kubernetes manifests, Grafana dashboards, and Prometheus rules combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with Prometheus using the Prometheus Operator | ✅ |
| [local-path-provisioner](./scripts/../k8s-apps/local-path-provisioner) | Utilize the local storage in each node | ✅ |
| [loki](./scripts/../k8s-apps/loki) | Like Prometheus, but for logs | ✅ |
| [longhorn](./scripts/../k8s-apps/longhorn) | Cloud-Native distributed storage built on and for Kubernetes | ❌ |
| [metallb](./scripts/../k8s-apps/metallb) | A network load-balancer implementation for Kubernetes using standard routing protocols | ✅ |
| [microbin](./scripts/../k8s-apps/microbin) | A secure, configurable file-sharing and URL shortening web app | ✅ |
| [mosquitto](./scripts/../k8s-apps/mosquitto) | Open source MQTT broker | ✅ |
| [nextcloud](./scripts/../k8s-apps/nextcloud) | A safe home for all your data | ✅ |
| [niks3](./scripts/../k8s-apps/niks3) | S3-backed Nix binary cache with garbage collection | ✅ |
| [openbao](./scripts/../k8s-apps/openbao) | Open source, community-driven fork of Vault managed by the Linux Foundation | ✅ |
| [opencloud](./scripts/../k8s-apps/opencloud) | Excellent file sharing | ❌ |
| [opentelemetry-collector](./scripts/../k8s-apps/opentelemetry-collector) | Vendor-agnostic implementation on how to receive, process and export telemetry data | ✅ |
| [opentelemetry-operator](./scripts/../k8s-apps/opentelemetry-operator) | Kubernetes Operator for OpenTelemetry Collector | ✅ |
| [paperless-ngx](./scripts/../k8s-apps/paperless-ngx) | Scan, index and archive all your physical documents | ✅ |
| [pocket-id](./scripts/../k8s-apps/pocket-id) | Simple and easy-to-use OIDC provider that allows users to authenticate with their passkeys to your services | ✅ |
| [reloader](./scripts/../k8s-apps/reloader) | A Kubernetes controller to watch changes in ConfigMap and Secrets and do rolling upgrades on Pods with their associated Deployment, StatefulSet, DaemonSet and DeploymentConfig | ✅ |
| [sablier](./scripts/../k8s-apps/sablier) | A free and open-source software to start workloads on demand and stop them after a period of inactivity | ✅ |
| [satisfactory-server](./scripts/../k8s-apps/satisfactory-server) | Satisfactory server | ❌ |
| [scrobble-deduplicator](./scripts/../k8s-apps/scrobble-deduplicator) | Periodically delete duplicate Last.fm scrobbles | ✅ |
| [snapshot-controller](./scripts/../k8s-apps/snapshot-controller) | Implements the control loop for CSI snapshot functionality | ❌ |
| [tailscale-operator](./scripts/../k8s-apps/tailscale-operator) | A Kubernetes Operator for Tailscale | ✅ |
| [traefik](./scripts/../k8s-apps/traefik) | A Traefik based Kubernetes ingress controller | ✅ |
| [vaultwarden](./scripts/../k8s-apps/vaultwarden) | Unofficial Bitwarden compatible server written in Rust | ✅ |
| [velero](./scripts/../k8s-apps/velero) | Backup and migrate Kubernetes applications and their persistent volumes | ✅ |
| [versity-gw](./scripts/../k8s-apps/versity-gw) | High-performance S3 translation service | ✅ |
| [zigbee2mqtt](./scripts/../k8s-apps/zigbee2mqtt) | Zigbee to MQTT bridge | ✅ |
<!-- END deployed-apps -->


## Get started

### Requirments

```bash
# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install helm
curl https://raw.githubusercontent.com/helm/helm/main/install-helm.sh | bash

# Install k0s
curl -sSLf https://get.k0s.sh | sudo bash
`
### Install
Step 1: Create a k0s Configuration File

Create `k0s.yaml` in your project root (or use the default). The bootstrap script references `./k0s.yaml`, so create one:

```bash
k0s default-config > k0s.yaml
```

Customize it for your needs. Common options:
- Enable containerd features
- Configure storage
- Set up network plugin options

### Step 2: Prepare Your Secrets

The bootstrap script expects a **GitLab token** for pulling secrets. You'll need:

```bash
./scripts/bootstrap.sh YOUR_GITLAB_TOKEN
```

This token should have access to your secrets repository or API.

### Step 3: Run Bootstrap

The bootstrap script does the following:
1. **SSH into your cluster node** and:
   - Installs k0s as a controller with worker role
   - Starts k0s
   - Gets kubeconfig

2. **Creates namespaces**:
   - `external-secrets`
   - `argocd`

3. **Creates secret** with your GitLab token

4. **Installs core components**:
   - **Cilium** (networking)
   - **External Secrets Operator** (secret management)
   - **ArgoCD** (GitOps controller)

5. **Deploys the "App of Apps"** - ArgoCD ApplicationSet that bootstraps all other apps

### Step 4: Access ArgoCD UI

Once bootstrap completes:

```bash
# Port forward to ArgoCD
kubectl port-forward -n argocd svc/argocd-server 8080:443

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Then visit: `https://localhost:8080`

### Step 5: Configure Your Secrets Backend

The setup uses **External Secrets Operator** with **OpenBao** (fork of Vault). Check:
```
homelab-gitops/terraform/secrets/
```

You'll need to:
1. Set up OpenBao as your secret store
2. Store secrets there (API keys, tokens, passwords)
3. External Secrets Operator will inject them into your cluster

### Step 6: Customize for Your Environment

Edit these files for your setup:

- **`k0s.yaml`** - k0s cluster configuration
- **`k8s-apps/*/values.yaml`** - Individual app configurations
- **`.sops.yaml`** - Secret encryption settings (if using SOPS)

### Step 7: Optional - Deploy Selectively

If you don't want all 50+ apps immediately, edit `argocd-apps/applicationset.yaml` to deploy only what you need, then gradually enable others.

## Quick Reference Commands

```bash
# Check cluster status
kubectl get nodes
kubectl get pods --all-namespaces

# Check ArgoCD apps
kubectl get applications -n argocd

# Uninstall everything
./scripts/uninstall.sh

# SSH into cluster node
ssh user@your-homelab-host

# Get current deployments
./scripts/update-deployed-apps.sh
