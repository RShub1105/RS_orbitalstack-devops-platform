#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARGOCD_VERSION="7.3.8"
INGRESS_NGINX_VERSION="4.11.2"
CERT_MANAGER_VERSION="v1.15.3"
EXTERNAL_SECRETS_VERSION="0.9.20"

if ! command -v kind >/dev/null 2>&1; then
  echo "kind is required"
  exit 1
fi

if ! kind get clusters | grep -q "^orbitalstack$"; then
  kind create cluster --config "${ROOT_DIR}/kind/cluster.yaml"
fi

if ! docker ps --format '{{.Names}}' | grep -q '^kind-registry$'; then
  docker run -d --restart=always -p 5001:5000 --name kind-registry registry:2
fi

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v${INGRESS_NGINX_VERSION}/deploy/static/provider/kind/deploy.yaml
kubectl wait --namespace ingress-nginx --for=condition=Available deployment/ingress-nginx-controller --timeout=180s

helm repo add jetstack https://charts.jetstack.io >/dev/null
helm repo add argo https://argoproj.github.io/argo-helm >/dev/null
helm repo add external-secrets https://charts.external-secrets.io >/dev/null
helm repo update >/dev/null

kubectl create namespace cert-manager --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --version "${CERT_MANAGER_VERSION#v}" \
  --set installCRDs=true

kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --version "${ARGOCD_VERSION}" \
  --values "${ROOT_DIR}/argocd/argocd-values.yaml"

kubectl create namespace external-secrets --dry-run=client -o yaml | kubectl apply -f -
helm upgrade --install external-secrets external-secrets/external-secrets \
  --namespace external-secrets \
  --version "${EXTERNAL_SECRETS_VERSION}"

kubectl apply -f "${ROOT_DIR}/argocd/projects"
kubectl apply -f "${ROOT_DIR}/argocd/rbac"
kubectl apply -f "${ROOT_DIR}/argocd/notifications"
kubectl apply -f "${ROOT_DIR}/argocd/health"
kubectl apply -f "${ROOT_DIR}/argocd/applications"

echo "Cluster bootstrap complete."

