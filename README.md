# DevOps-nginx-demo

This is nginx based server, which is configured for basic testing purpose in which default.conf file is configured for some basic responces. We can use this for monitoring purpose.

Steps to implement:

Step_01: Build docker image for monitoring web-server
$docker build -t web-server

Step_02: Create docker network:
$docker network create my_network

Step_03: Run docker container in the created network:
$docker run -d -p 80:80--name web-server --network my_network web-server

Note: Some imp command for debug purpose:
docker exec -it <container-id> /bin/bash
docker logs <container-id>
docker inspect <container-id>