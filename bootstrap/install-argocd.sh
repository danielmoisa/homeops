#!/usr/bin/env bash
set -euo pipefail

echo "→ Adding ArgoCD Helm repo..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

echo "→ Installing ArgoCD..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --version 7.8.23 \
  --values argocd/values.yaml \
  --wait

echo ""
echo "✓ ArgoCD ready"
echo ""
echo "Admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
echo ""
echo "Run next:"
echo "  kubectl apply -f bootstrap/root-app.yaml"
