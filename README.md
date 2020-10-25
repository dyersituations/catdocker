## CatDocker

Hosting for the CatCMS project using ```docker-compose```. In order to add a new domain, create a new folder with ```docker-compose.yml```, ```docker-compose.override.yml```, and ```.env```, changing values as applicable.

## Server Setup

- [Initial setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)
- [Docker setup](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [Docker Compose setup](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-20-04-quickstart)
- ```docker network create nginx-proxy```

## Build Site

- ```docker-compose build --no-cache```
- ```docker-compose push```

## Site Deployment

- ```scp docker-compose.yml dockeruser@<IP_ADDRESS>:~/```
- ```docker-compose up -d```

## Connect to Container

- ```docker exec -it <CONTAINER_NAME> bash```

## Update Site

- ```docker-compose pull && docker-compose up -d```

## Cleanup Docker

- ```docker rm -vf $(docker ps -a -q)```
- ```docker rmi -f $(docker images -a -q)```
- ```docker volume prune```