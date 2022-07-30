#!/bin/bash

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
  params=()

  if [[ "$CLUSTER" ]]; then
    params+=("--cluster=${CLUSTER}")
  fi

  if [[ "$USER" ]]; then
    params+=("--user=${USER}")
  fi

  if [[ "$NAMESPACE" ]]; then
    params+=("--namespace=${NAMESPACE}")
  fi

  if [[ "$INSECURE" ]]; then
    params+=("--insecure-skip-tls-verify")
  fi

  kubectl "${@}" "${params[@]}";
}

POD_NAME=$(kube_client get pod -l "${LABELS}" -o name | shuf -n1)
while true; do
  kube_client port-forward "${POD_NAME}" "${PORTS}" --address="0.0.0.0";
done
