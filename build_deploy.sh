#!/bin/bash
set -ex

login_container_registry() {

    local USER="$1"
    local PASSWORD="$2"
    local REGISTRY="$3"

    podman login "-u=${USER}" "--password-stdin" "$REGISTRY" <<< "$PASSWORD"
}

IMAGE_NAME="quay.io/cloudservices/envoy"
IMAGE_TAG=$(git rev-parse --short=7 HEAD)

login_container_registry "$QUAY_USER" "$QUAY_TOKEN" "quay.io"
login_container_registry "$RH_REGISTRY_USER" "$RH_REGISTRY_TOKEN" "registry.redhat.io"

podman build -t "${IMAGE_NAME}:${IMAGE_TAG}" -t "${IMAGE_NAME}:latest" .
podman push "${IMAGE_NAME}:${IMAGE_TAG}"
podman push "${IMAGE_NAME}:latest"
