# Makefile — convenience shortcuts for local cluster management

KUBECONFIG ?= $(HOME)/.kube/config

##@ Setup

.PHONY: install-k3s
install-k3s: ## Install K3S (disables built-in traefik)
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--disable traefik" sh -
	mkdir -p $(HOME)/.kube
	sudo cp /etc/rancher/k3s/k3s.yaml $(HOME)/.kube/config
	sudo chown $(USER):$(USER) $(HOME)/.kube/config
	@echo "K3S installed. Run: kubectl get nodes"

.PHONY: install-tools
install-tools: ## Install helm, argocd CLI, kubectl
	@echo "Installing Helm..."
	curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
	@echo "Installing ArgoCD CLI..."
	curl -sSL -o /tmp/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
	chmod +x /tmp/argocd && sudo mv /tmp/argocd /usr/local/bin/argocd
	@echo "Done. Verify: helm version && argocd version --client"

.PHONY: install-argocd
install-argocd: ## Install ArgoCD via Helm
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	helm repo add argo https://argoproj.github.io/argo-helm
	helm repo update
	helm upgrade --install argocd argo/argo-cd -n argocd -f argocd/values.yaml
	@echo "Waiting for ArgoCD server..."
	kubectl -n argocd rollout status deploy/argocd-server --timeout=120s

.PHONY: bootstrap
bootstrap: ## Apply root App-of-Apps to ArgoCD
	kubectl apply -f bootstrap/root-app.yaml
	@echo "Bootstrap applied. Watch: kubectl get applications -n argocd"

##@ Access

.PHONY: argocd-password
argocd-password: ## Print initial ArgoCD admin password
	@kubectl -n argocd get secret argocd-initial-admin-secret \
		-o jsonpath="{.data.password}" | base64 -d && echo

.PHONY: argocd-ui
argocd-ui: ## Port-forward ArgoCD UI to localhost:8080
	@echo "Open http://localhost:8080 — user: admin"
	kubectl port-forward svc/argocd-server -n argocd 8080:80

.PHONY: grafana-ui
grafana-ui: ## Port-forward Grafana to localhost:3000
	@echo "Open http://localhost:3000 — user: admin / pass: admin"
	kubectl port-forward svc/prometheus-grafana -n monitoring 3000:80

.PHONY: vault-ui
vault-ui: ## Port-forward Vault UI to localhost:8200
	@echo "Open http://localhost:8200 — token: root"
	kubectl port-forward svc/vault -n vault 8200:8200

.PHONY: minio-ui
minio-ui: ## Port-forward Minio console to localhost:9001
	@echo "Open http://localhost:9001 — user: minioadmin / pass: minioadmin"
	kubectl port-forward svc/minio-console -n minio 9001:9001

.PHONY: keycloak-ui
keycloak-ui: ## Port-forward Keycloak to localhost:8088
	@echo "Open http://localhost:8088 — user: admin / pass: admin"
	kubectl port-forward svc/keycloak -n keycloak 8088:80

##@ Cleanup

.PHONY: uninstall-k3s
uninstall-k3s: ## Remove K3S from the system
	/usr/local/bin/k3s-uninstall.sh

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
