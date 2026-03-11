# https://bitbucket.org/l2jserver/l2j-server-login-docker

FROM alpine:3.23 AS base-image

ENV L2JCLI_URI=https://git@bitbucket.org/l2jserver/l2j-server-cli.git

ENV L2J_DIR=/opt/l2j
ENV L2J_SOURCE_DIR="$L2J_DIR/source"

ENV L2JCLI_DIR=cli
ENV L2JLOGIN_DIR=login


FROM base-image AS build

ARG L2JCLI_BRANCH=master

COPY --from=local-login . $L2J_SOURCE_DIR/$L2JLOGIN_DIR/

RUN \
  apk update && apk --no-cache add git openjdk25-jdk && \
  mkdir -p "$L2J_SOURCE_DIR" && \
  git clone --branch "$L2JCLI_BRANCH" --single-branch "$L2JCLI_URI" "$L2J_SOURCE_DIR/$L2JCLI_DIR" && \
  cd "$L2J_SOURCE_DIR/$L2JCLI_DIR" && chmod +x mvnw && ./mvnw package -DskipTests && \
  cd "$L2J_SOURCE_DIR/$L2JLOGIN_DIR" && chmod +x mvnw && ./mvnw package -DskipTests


FROM base-image AS deploy
LABEL maintainer="l2j-server" website="l2jserver.com"

ENV L2J_DEPLOY_DIR="$L2J_DIR/deploy"
ENV L2J_CUSTOM_DIR="$L2J_DIR/custom"
ENV L2J_HOME="$L2J_DIR"

WORKDIR "$L2J_DEPLOY_DIR"

COPY --from=build "$L2J_SOURCE_DIR/$L2JCLI_DIR/target/*.zip" "$L2J_SOURCE_DIR/$L2JLOGIN_DIR/target/*.zip" "$L2J_DEPLOY_DIR/"
RUN \
  apk update && apk --no-cache add unzip openjdk25-jre mariadb-client && \
  mkdir -p "$L2J_CUSTOM_DIR" "$L2J_DEPLOY_DIR/$L2JCLI_DIR/logs" "$L2J_DEPLOY_DIR/$L2JLOGIN_DIR/logs" && \
  unzip "$L2J_DEPLOY_DIR/*cli*.zip" -d "$L2J_DEPLOY_DIR/$L2JCLI_DIR" && \
  unzip "$L2J_DEPLOY_DIR/*login*.zip" -d "$L2J_DEPLOY_DIR/$L2JLOGIN_DIR" && \
  cd "$L2J_DEPLOY_DIR" && rm *.zip && apk del unzip
COPY resources/ /
RUN chmod +x "/entrypoint.sh" "/init_database.sh" "/procman.sh"

ENTRYPOINT ["/entrypoint.sh"]
