#!/usr/bin/env bash
set -euo pipefail

namespaces=("orbital-staging" "monitoring" "argocd")
for ns in "${namespaces[@]}"; do
  kubectl get ns "${ns}" >/dev/null
done

kubectl -n orbital-staging rollout status deploy/telemetry-ingestor --timeout=180s
kubectl -n orbital-staging rollout status deploy/ota-controller --timeout=180s
kubectl -n orbital-staging rollout status deploy/device-api --timeout=180s
kubectl -n orbital-staging rollout status statefulset/mqtt-broker --timeout=180s || true

kubectl -n orbital-staging get svc mqtt-broker telemetry-ingestor ota-controller device-api
kubectl -n monitoring get pods
kubectl -n monitoring get prometheusrules
kubectl -n monitoring get servicemonitors
kubectl -n monitoring get pods -l app.kubernetes.io/name=loki

echo "Running endpoint checks"
kubectl -n orbital-staging run curl-check --rm -i --restart=Never --image=curlimages/curl:8.7.1 -- \
  curl -fsS http://device-api:9000/health/ready
kubectl -n orbital-staging run curl-check-2 --rm -i --restart=Never --image=curlimages/curl:8.7.1 -- \
  curl -fsS http://telemetry-ingestor:8080/ready
kubectl -n orbital-staging run curl-check-3 --rm -i --restart=Never --image=curlimages/curl:8.7.1 -- \
  curl -fsS http://ota-controller:7070/ready

echo "Verification complete."

