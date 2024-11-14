#!/usr/bin/env bash

#*******************************************************************************
# Copyright (c) 2024 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html
# SPDX-License-Identifier: EPL-2.0
#*******************************************************************************

# Bash strict-mode
set -o errexit
set -o nounset
set -o pipefail

NEXUS_VERSION="2.15.2-03"
IMAGE_NAME="eclipsecbi/nexus"

docker build -t "${IMAGE_NAME}:${NEXUS_VERSION}" -t "${IMAGE_NAME}:latest" --build-arg "NEXUS_VERSION=${NEXUS_VERSION}" .

echo "Push to DockerHub?"
read -p "Press enter to continue or CTRL-C to stop the script"
docker push "${IMAGE_NAME}:${NEXUS_VERSION}"
docker push "${IMAGE_NAME}:latest"