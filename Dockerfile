# Copyright 2017 Red Hat
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ------------------------------------------------------------------------
#
# This is a Dockerfile for the amq-broker-7/amq-broker-77-openshift:7.7 image.

FROM registry.redhat.io/amq7/amq-broker:latest

USER root

# Environment variables
ENV \
    AB_JOLOKIA_AUTH_OPENSHIFT="true" \
    AB_JOLOKIA_HTTPS="true" \
    AB_JOLOKIA_PASSWORD_RANDOM="true" \
    HOME="/home/jboss" \
    JBOSS_CONTAINER_AMQ_S2I_MODULE="/opt/jboss/container/amq/s2i" \
    JBOSS_CONTAINER_JAVA_JVM_MODULE="/opt/jboss/container/java/jvm" \
    JBOSS_CONTAINER_JAVA_PROXY_MODULE="/opt/jboss/container/java/proxy" \
    JBOSS_CONTAINER_JOLOKIA_MODULE="/opt/jboss/container/jolokia" \
    JBOSS_CONTAINER_S2I_CORE_MODULE="/opt/jboss/container/s2i/core/" \
    JBOSS_CONTAINER_UTIL_LOGGING_MODULE="/opt/jboss/container/util/logging/" \
    JBOSS_IMAGE_NAME="amq-broker-7/amq-broker-77-openshift" \
    JBOSS_IMAGE_VERSION="7.7" \
    JOLOKIA_VERSION="1.6.2" \
    S2I_SOURCE_DEPLOYMENTS_FILTER="*" 

# Labels
LABEL \
      com.redhat.component="amq-broker-openshift-container"  \
      description="Red Hat AMQ Broker 7.7.0 OpenShift container image"  \
      io.cekit.version="2.2.5"  \
      io.fabric8.s2i.version.jolokia="1.6.2-redhat-00002"  \
      io.k8s.description="A reliable messaging platform that supports standard messaging paradigms for a real-time enterprise."  \
      io.k8s.display-name="Red Hat AMQ Broker 7.7.0"  \
      io.openshift.expose-services="8778/tcp:uec,5671/tcp:amqps,5672/tcp:amqp,1883/tcp:mqtt,8161/tcp:patrol-snmp,9876/tcp:sd,7800/tcp:asr,8888/tcp:ddi-tcp-1"  \
      io.openshift.s2i.destination="/tmp"  \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i"  \
      io.openshift.tags="messaging,amq,java,jboss,xpaas"  \
      maintainer="rkieley@redhat.com"  \
      name="amq-broker-7/amq-broker-77-openshift"  \
      org.concrt.version="2.2.5"  \
      org.jboss.container.deployments-dir="/deployments"  \
      summary="Red Hat AMQ Broker 7.7.0 OpenShift container image"  \
      version="7.7" 

# Exposed ports
EXPOSE 8778 5671 5672 1883 8161 9876 61613 61612 61616 61617 7800 8888
# Add scripts used to configure the image

ADD management.xml /opt/amq/conf/

ADD artemis.profile /opt/amq/conf


RUN sed -i "s/configure \$instanceDir/&\nif [ -n \"\${ARTEMIS_AUTH}\" ] ; then\n   userDetails=\"\${ARTEMIS_AUTH}\"\n   IFS=\",\" read -a individualUser <<< \$userDetails\n   for (( i=0; i<\${#individualUser[@]}; i++ )); do\n     IFS=\":\" read -a userSplit <<< \"\${individualUser[\$i]}\"\n      sh \${instanceDir}\/bin\/artemis user add --user \"\${userSplit[0]}\" --password \"\${userSplit[1]}\" --role \"\${userSplit[2]}\"\n   done\n fi\n /" /opt/amq/bin/launch.sh

USER 185



# Specify the working directory
WORKDIR /home/jboss

	
CMD ["/opt/amq/bin/launch.sh", "start"]

