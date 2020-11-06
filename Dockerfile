FROM jenkins/inbound-agent:4.6-1-jdk11

USER root

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections && \
    apt-get -y update && \
    apt-get -y install apt-utils dialog jq libncurses5 make maven nodejs uuid-runtime

ARG DOCKER_APP=docker
ARG DOCKER_VERSION=19.03.13
ARG DOCKER_ARCH=x86_64
RUN wget https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/${DOCKER_APP}-${DOCKER_VERSION}.tgz \
    -O ${DOCKER_APP}.tgz && \
    tar -xvf ${DOCKER_APP}.tgz && \
    mv ${DOCKER_APP}/${DOCKER_APP} /usr/local/bin/${DOCKER_APP} && \
    rm -rf ${DOCKER_APP}.tgz

ARG DOCKER_COMPOSE_APP=docker-compose
ARG DOCKER_COMPOSE_VERSION=1.27.4
ARG DOCKER_COMPOSE_ARCH=Linux-x86_64
RUN wget https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/${DOCKER_COMPOSE_APP}-${DOCKER_COMPOSE_ARCH} \
    -O ${DOCKER_COMPOSE_APP} && \
    chmod +x ${DOCKER_COMPOSE_APP} && \
    mv ${DOCKER_COMPOSE_APP} /usr/local/bin/${DOCKER_COMPOSE_APP}

ARG APP=sonar-scanner
ARG VERSION=4.5.0.2216
ARG ARCH=linux
ENV SONAR_RUNNER_HOME=/usr/lib/sonar-scanner
RUN wget https://binaries.sonarsource.com/Distribution/${APP}-cli/${APP}-cli-${VERSION}-${ARCH}.zip \
	-O ${APP}.zip && \
	unzip ${APP}.zip && \
	mv ${APP}-${VERSION}-${ARCH} $SONAR_RUNNER_HOME && \
	ln -s $SONAR_RUNNER_HOME/bin/${APP} /usr/local/bin/${APP} && \
	rm -rf ${APP}.zip

ARG OWASP_DC_APP=dependency-check
ARG OWASP_DC_VERSION=6.0.3
ENV RUN_DEPENDENCY_CHECK=/usr/share/${OWASP_DC_APP}/bin/${OWASP_DC_APP}.sh
RUN wget https://dl.bintray.com/jeremy-long/owasp/${OWASP_DC_APP}-${OWASP_DC_VERSION}-release.zip \
    -O ${OWASP_DC_APP}.zip && \
    unzip ${OWASP_DC_APP}.zip && \
    mv ${OWASP_DC_APP} /usr/share/${OWASP_DC_APP} && \
    rm -rf ${OWASP_DC_APP}.zip
