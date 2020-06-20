FROM alpine:latest

COPY entry-point.sh /entry-point.sh

ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk

RUN apk update \ 
    && apk --no-cache add openjdk11-jdk maven mariadb-client openjdk11-jre unzip git \
    && mkdir -p /opt/l2j/target \
    && mkdir -p /opt/l2j/server/cli \
    && mkdir -p /opt/l2j/server/login \
    && mkdir -p /opt/l2j/server/game \
    && java --version \
    && cd /opt/l2j/target/ \
    && git clone https://git@bitbucket.org/l2jserver/l2j-server-cli.git cli \
    && git clone https://git@bitbucket.org/l2jserver/l2j-server-login.git login \
    && git clone https://git@bitbucket.org/l2jserver/l2j-server-game.git game \
    && git clone https://git@bitbucket.org/l2jserver/l2j-server-datapack.git datapack \
    && cd /opt/l2j/target/cli \
    && mvn install \
    && cd /opt/l2j/target/login \
    && mvn install \
    && cd /opt/l2j/target/game \
    && mvn install \
    && cd /opt/l2j/target/datapack \
    && mvn install \
    && unzip /opt/l2j/target/cli/target/*.zip -d /opt/l2j/server/cli \
    && unzip /opt/l2j/target/login/target/*.zip -d /opt/l2j/server/login \
    && unzip /opt/l2j/target/game/target/*.zip -d /opt/l2j/server/game \
    && unzip /opt/l2j/target/datapack/target/*.zip -d /opt/l2j/server/game \
    && rm -rf /opt/l2j/target/ \
    && apk del maven git \
    && chmod +x /entry-point.sh

WORKDIR /opt/l2j/server

EXPOSE 7777 2106

ENTRYPOINT [ "/entry-point.sh" ]

HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "time" ]
