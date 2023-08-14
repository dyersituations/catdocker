## CatDocker
Hosting for the CatCMS project using `docker compose`.

## Server Setup
- [Initial setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)
- [Docker setup](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [Docker Compose setup](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-20-04-quickstart)
- `docker network create nginx-proxy`

## Local Setup
- [Install docker compose](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-20-04-quickstart)
- [Install Ruby 2.7.0, Rails 5.2.4.4, and Node.js](https://gorails.com/setup)
- `sudo apt-get install -y imagemagick libmagickwand-dev`
- `gem install bundler:2.1.4`

## Add Site
- Create folder for new domain
- Copy `docker-compose.yml`
- Copy `docker-compose.override.yml`
- Change values to match new domain
 
## Build Site
- Ensure domain folder has `.env`

```
  RAILS_ENV=production
  SECRET_KEY_BASE=${openssl rand -hex 64}
```

- Run the following commands

```bash
cd $REPO_ROOT_FOLDER
# Only if needed
git submodule init
git submodule update --recursive --remote
cd $REPO_DOMAIN_FOLDER
sudo docker compose build --no-cache
sudo docker login
sudo docker compose push
```

## New Site Deployment
```bash
ssh root@$IP_ADDRESS
mkdir /home/dockeruser/$DOMAIN
scp docker-compose.yml root@$IP_ADDRESS:/home/dockeruser/$DOMAIN
docker-compose up -d
```

## Update Site
```bash
ssh root@$IP_ADDRESS
cd /home/dockeruser/$DOMAIN
# Pulls new image, recreates container, runs migrations
docker-compose pull && docker-compose up -d
```

## Restart Droplet
- Toggle on/off in DigitalOcean dashboard
- Start applications
```bash
ssh root@$IP_ADDRESS
cd /home/dockeruser/proxy
docker-compose up -d
# For each domain
cd /home/dockeruser/$DOMAIN
docker-compose up -d
```

## Backup Site
```bash
ssh root@$IP_ADDRESS
docker container ls
docker cp <CONTAINER_ID>:/var/www backup
# Exit Docker container
exit
# Exit SSH
exit
cd ~/git
sudo scp -r root@143.110.147.142:backup backup
ssh root@$IP_ADDRESS
rm -rf backup
```

## Connect to Container
```bash
docker container ls
docker exec -it $CONTAINER_NAME bash
```

## View Container Logs
```bash
docker container ls
docker logs -f $CONTAINER_NAME
```

## Reset Docker
```bash
docker rm -vf $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
docker volume prune
docker network prune
docker system prune
```

## Reset/Reconnect SSH
```bash
# Reset password via DigitalOcean droplet settings
# Open droplet recovery console

# Enable password auth
sudo nano /etc/ssh/sshd_config
# Change "PasswordAuthentication yes"

# Delete old keys
nano ~/.ssh/authorized_keys

# Restart SSH
sudo service sshd restart

# Create SSH key locally
ssh-keygen

# Add RSA key to DigitalOcean security settings and delete old keys

# Copy SSH from local machine
ssh-copy-id root@$IP_ADDRESS

# SSH from local machine
ssh root@$IP_ADDRESS

# From recovery console again
sudo nano /etc/ssh/sshd_config
# Change "PasswordAuthentication no"

sudo service sshd restart
```
