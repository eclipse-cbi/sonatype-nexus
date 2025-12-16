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

IFS=$'\n\t'
SCRIPT_FOLDER="$(dirname "$(readlink -f "${0}")")"
ROOT_DIR="${SCRIPT_FOLDER}"

release_name_staging="nexus3-staging"
release_name_production="nexus3-production"
chart_name="nexus3"
namespace="repo3-eclipse-org"

environment="${1:-}"
image_tag="${2:-}" #optional

# check that environment is not empty
if [[ -z "${environment}" ]]; then
  printf "ERROR: an environment ('staging' or 'production') must be given.\n"
  exit 1
fi

if [[ "${environment}" == "staging" ]]; then
  values_file="${ROOT_DIR}/charts/${chart_name}/values-staging.yaml"
  release_name="${release_name_staging}"
elif [[ "${environment}" == "production" ]]; then
  values_file="${ROOT_DIR}/charts/${chart_name}/values.yaml"
  release_name="${release_name_production}"
else
  printf "ERROR: Unknown environment. Only 'staging' or 'production' are supported.\n"
  exit 1
fi

# Check for license file
license_file="${ROOT_DIR}/charts/${chart_name}/secrets/nxrm-license.lic"
if [[ ! -f "${license_file}" ]]; then
  printf "ERROR: License file not found at '%s'.\n" "${license_file}"
  printf "Please ensure the license file exists before deploying.\n"
  exit 1
fi
echo "License file found at '${license_file}'."


if helm list -n "${namespace}" | grep "${release_name}" > /dev/null; then
  echo "Found installed Helm chart for release name '${release_name}'. Upgrading..."
  action="upgrade"
  helm diff "upgrade" "${release_name}" "${ROOT_DIR}/charts/${chart_name}" -f "${values_file}" --namespace "${namespace}" --context 0
  read -rsp $'Once you are ok, press any key to continue...\n' -n1
else
  echo "Found no installed Helm chart for release name '${release_name}'. Installing..."
  action="install"
fi

if [[ -z "${image_tag}" ]]; then
 helm "${action}" "${release_name}" "${ROOT_DIR}/charts/${chart_name}" -f "${values_file}" --namespace "${namespace}"
else
 helm "${action}" "${release_name}" "${ROOT_DIR}/charts/${chart_name}" -f "${values_file}" --set image.tag="${image_tag}" --namespace "${namespace}"
fi
