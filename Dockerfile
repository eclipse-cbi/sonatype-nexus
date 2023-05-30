#*******************************************************************************
# Copyright (c) 2019 Eclipse Foundation and others.
# This program and the accompanying materials are made available
# under the terms of the Eclipse Public License 2.0
# which is available at http://www.eclipse.org/legal/epl-v20.html,
# or the MIT License which is available at https://opensource.org/licenses/MIT.
# SPDX-License-Identifier: EPL-2.0 OR MIT
#*******************************************************************************
FROM eclipsecbi/adoptopenjdk-coreutils:openjdk8-openj9-alpine-slim

# See https://help.sonatype.com/repomanager2/download/download-archives---repository-manager-oss
ARG NEXUS_VERSION=2.15.1-02
ARG NEXUS_DOWNLOAD_URL=https://download.sonatype.com/nexus/oss/nexus-${NEXUS_VERSION}-bundle.tar.gz

ENV NEXUS_WORK=/var/nexus/work
ENV NEXUS_HOME=/var/nexus/home

RUN apk add --no-cache \
  jq

COPY scripts/nexus.sh /usr/local/bin/nexus.sh

RUN chgrp 0 /usr/local/bin/nexus.sh && chmod g+x /usr/local/bin/nexus.sh && \
  mkdir -p "${NEXUS_WORK}" && chmod g+w "${NEXUS_WORK}" && \
  mkdir -p "${NEXUS_HOME}" && \
  curl --fail --silent --location --retry 3 "${NEXUS_DOWNLOAD_URL}" | tar xz --strip-components=1 -C "${NEXUS_HOME}" && \
  chgrp -R 0 "${NEXUS_HOME}" && chmod -R g+w "${NEXUS_HOME}" && \
  echo "# See https://issues.sonatype.org/browse/NEXUS-10233" >> "${NEXUS_HOME}/conf/nexus.properties" && \
  echo "org.sonatype.nexus.proxy.maven.routing.Config.prefixFileMaxSize=500000" >> "${NEXUS_HOME}/conf/nexus.properties"

ENV CONTEXT_PATH /

VOLUME ${NEXUS_WORK}
WORKDIR ${NEXUS_HOME}
EXPOSE 8081

ENTRYPOINT ["uid_entrypoint", "/usr/bin/dumb-init", "--", "/usr/local/bin/nexus.sh"]

USER 10001
