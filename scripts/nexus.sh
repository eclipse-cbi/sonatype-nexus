#!/usr/bin/env bash
#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html,
# or the MIT License which is available at https://opensource.org/licenses/MIT.
# SPDX-License-Identifier: EPL-2.0 OR MIT
#*******************************************************************************
set -o errexit
set -o nounset
set -o pipefail

# if `docker run` without arguments, starts nexus
if [[ $# -lt 1 ]]; then
  exec java \
  -Dnexus-work="${NEXUS_WORK}" \
  -Dnexus-webapp-context-path="${CONTEXT_PATH}" \
  -Djava.util.prefs.userRoot="${NEXUS_WORK}/java_prefs" \
  ${JAVA_OPTS:-} \
  -cp "conf/:lib/*" \
  org.sonatype.nexus.bootstrap.Launcher "conf/jetty.xml" "conf/jetty-requestlog.xml" "${@:1}"
fi

# otherwise, assume user want to run his own process, for example a `bash` shell to explore this image
exec "$@"
