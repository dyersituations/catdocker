## CatDocker

Hosting for the CatCMS project using `docker-compose`.

## Server Setup

- [Initial setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)
- [Docker setup](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [Docker Compose setup](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-20-04-quickstart)
- `docker network create nginx-proxy`

## Init Repo

- `git submodule update --init --recursive`

## Add Site

- Create folder for new domain
- Copy `docker-compose.yml`
  - Change values to match new domain
- Copy `docker-compose.override.yml`
- Create `.env`s
  ```
  RAILS_ENV=production
  SECRET_KEY_BASE=${openssl rand -hex 64}
  ```

## Build Site

- `git submodule update --recursive --remote`
- `docker-compose build --no-cache`
- `docker login`
- `docker-compose push`

## Site Deployment

- `scp docker-compose.yml dockeruser@<IP_ADDRESS>:~/`
- `docker-compose up -d`

## Connect to Container

- `docker exec -it <CONTAINER_NAME> bash`

## Update Site

- `docker-compose pull && docker-compose up -d`

## Cleanup Docker

- `docker rm -vf $(docker ps -a -q)`
- `docker rmi -f $(docker images -a -q)`
- `docker volume prune`
- `docker network prune`
- `docker system prune`

## Reset/Reconnect SSH

- Connect via Digital Ocean Recovery Console
  - Reset root password if needed
- `sudo nano /etc/ssh/ssh_config`
  - `PasswordAuthentication yes`
- `sudo service sshd reload`
- `ssh-keygen -t ed25519`
- `ssh-copy-id <USER>@<IP_ADDRESS>`
- `sudo nano /etc/ssh/ssh_config`
  - `PasswordAuthentication no`
- `sudo service sshd reload`
