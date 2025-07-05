#!/bin/bash

ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    echo "Push arm64-box..."
    docker push tsxcloud/moria-arm:arm64
elif [[ "$ARCH" == "x86_64" ]]; then
    echo "Building for amd64..."
    docker push tsxcloud/moria-arm:amd64
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

docker manifest create --amend tsxcloud/moria-arm:latest \
  tsxcloud/moria-arm:amd64 \
  tsxcloud/moria-arm:arm64

docker manifest push --purge tsxcloud/moria-arm:latest
