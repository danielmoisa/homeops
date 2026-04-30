#!/bin/bash
set -e -u -o pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

export KUBECONFIG="${KUBECONFIG:-$HOME/.kube/config}"

echo "Starting Kubernetes bootstrap..."
echo "Project root: $PROJECT_ROOT"

# Create k3d cluster if it doesn't exist
if k3d cluster list | grep -q "homeops"; then
  echo "Cluster 'homeops' already exists, skipping creation..."
else
  echo "Creating k3d cluster..."
  k3d cluster create homeops \
    --agents 1 \
    --k3s-arg "--disable=traefik@server:0"
fi

echo "Waiting for node to be ready..."
kubectl wait --for=condition=Ready node --all --timeout=60s

echo "Creating namespaces..."
kubectl create ns external-secrets --dry-run=client -o yaml | kubectl apply -f -
kubectl create ns argocd --dry-run=client -o yaml | kubectl apply -f -

echo "Installing External Secrets Operator..."
cd "$PROJECT_ROOT/k8s-apps/external-secrets"
helm dependency update
helm template external-secrets --namespace external-secrets . | \
  kubectl apply --server-side --force-conflicts --namespace external-secrets -f -

echo "Waiting for External Secrets CRDs to be established..."
kubectl wait --for=condition=Established \
  crd/clustergenerators.generators.external-secrets.io \
  crd/clustersecretstores.external-secrets.io \
  crd/externalsecrets.external-secrets.io \
  --timeout=60s

echo "Waiting for External Secrets webhook to be ready..."
kubectl rollout status deployment/external-secrets-webhook \
  -n external-secrets --timeout=120s

echo "Re-applying External Secrets to pick up custom resources..."
helm template external-secrets --namespace external-secrets . | \
  kubectl apply --server-side --force-conflicts --namespace external-secrets -f -

echo "Installing ArgoCD..."
cd "$PROJECT_ROOT/k8s-apps/argocd"
helm dependency update
helm template argocd --namespace argocd . | \
  kubectl apply --server-side --force-conflicts --namespace argocd -f -

echo "Waiting for ArgoCD CRDs to be established..."
kubectl wait --for=condition=Established \
  crd/applications.argoproj.io \
  crd/appprojects.argoproj.io \
  --timeout=60s

echo "Waiting for ArgoCD server to be ready..."
kubectl rollout status deployment/argocd-server \
  -n argocd --timeout=120s

echo "Deploying App of Apps..."
kubectl apply --namespace argocd -f "$PROJECT_ROOT/argocd-apps/app-of-apps.yaml"

echo ""
echo "=========================================="
echo "Bootstrap complete!"
echo "=========================================="
echo ""
echo "Next steps:"
echo ""
echo "1. Check cluster status:"
echo "   kubectl get nodes"
echo ""
echo "2. Port forward to ArgoCD:"
echo "   kubectl port-forward -n argocd svc/argocd-server 8080:443"
echo ""
echo "3. In another terminal, get the admin password:"
echo "   kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
echo ""
echo "4. Open https://localhost:8080 in your browser"
echo ""
echo "5. Monitor app deployments:"
echo "   kubectl get applications -n argocd -w"
