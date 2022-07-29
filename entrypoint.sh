#!/bin/bash

if [[ -z "$CLUSTER" ]]; then
  echo "Container failed to start, CLUSTER not set"
  exit 1
fi

if [[ -z "$USER" ]]; then
  echo "Container failed to start, USER not set"
  exit 1
fi

if [[ -z "$NAMESPACE" ]]; then
  echo "Container failed to start, NAMESPACE not set"
  exit 1
fi

if [[ -z "$LABELS" ]]; then
  echo "Container failed to start, LABELS not set"
  exit 1
fi

if [[ -z "$PORTS" ]]; then
  echo "Container failed to start, PORTS not set"
  exit 1
fi

if [[ ! -f "/root/.kube/config" ]]; then
  echo "Container failed to start, kubeconfig not mapped"
  exit 1
fi

kube_client() {
  kubectl "${INSECURE:+'--insecure-skip-tls-verify'}" --cluster "${CLUSTER}" --user "${USER}" --namespace "${NAMESPACE}" "${@}";
}

POD_NAME=$(kube_client get pod -l "${LABELS}" -o name | shuf -n1)
while true; do
  kube_client port-forward "${POD_NAME}" "${PORTS}" --address="0.0.0.0";
done
