# L2j Server Docker

## Requirements 

### Windows 10

[Install Docker for Windows](https://hub.docker.com/editions/community/docker-ce-desktop-windows)

After the installation enable the following checkbox in docker desktop > settings

`[x] Expose daemon on tcp://localhost:2375 without TLS`

### Linux

[Install docker for Centos](https://docs.docker.com/engine/install/centos/)

[Install docker for Debian](https://docs.docker.com/engine/install/debian/)

Then start the linux service

`systemctl status docker.service`

## Use docker-compose.yml to start

After the docker installation run the following command in any Linux / Windows terminal into the l2j-server-docker folder to get your local server running

`docker-compose -f "docker-compose.yml" up -d`

Wait until the server is fully deployed and connected to 127.0.0.1 and you are ready to go.

### Logging the server

If you want to check the logs while the server is starting/running use a terminal with the command

`docker logs l2j-server-docker --tail 50 -f` 

### Attaching a shell to check the container files manually

Attach a shell to navigate around the server container files

`docker exec -it l2j-server-docker /bin/sh -c "[ -e /bin/bash ] && /bin/bash || /bin/sh"`

### Configurable environments

The default values can be modified in the docker-compose.yml file

- SERVER_IP : Your private or public server IP  (default: "127.0.0.1")
- JAVA_XMS : Initial memory allocation pool (default: "512m")
- JAVA_XMX : Maximum memory allocation pool (default: "2g")
- RATE_XP : Rates for XP Gain (default: "1")
- RATE_SP : Rates for SP Gain (default: "1")
- ADMIN_RIGHTS : Everyone has Admin rights (default: "False")

### Managing the cluster with docker-compose.yml

Start the cluster (the first time)

`docker-compose -f "docker-compose.yml" up -d`

Stop the cluster

`docker-compose -f "docker-compose.yml" down`

Restart the cluster

`docker-compose -f "docker-compose.yml" up -d --build`

## Customize your own Docker images

If you want recreate the images yourself checkout the following Dockerfiles repositories

[yobasystems/alpine-mariadb](https://github.com/yobasystems/alpine-mariadb)

[l2jserver/l2j-server-docker](https://bitbucket.org/l2jserver/l2j-server-docker)

Just rename the images, customize and use them with your own docker-compose file.

## Troubleshooting

You should use `down` to stop the cluster but if you are experiencing problems with the main deploy, also you can create a .bat file to remove all the current containers

`@echo off`

`FOR /f "tokens=*" %%i IN ('docker ps -aq') DO docker rm %%i`

`FOR /f "tokens=*" %%i IN ('docker images --format "{{.ID}}"') DO docker rmi %%i`

But most cases it should be enough

`docker image prune -a`

`docker system prune -a`

# License

L2J Server is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Please read the complete [LICENSE](https://bitbucket.org/l2jserver/l2j-server-docker/src/master/LICENSE.md)