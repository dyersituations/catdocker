## CatDocker

Hosting for the [CatCMS](https://github.com/dyersituations/catcms) project using [Docker Compose](https://docs.docker.com/compose/).

## Project Setup

The steps below rely on a [Digital Ocean](https://www.digitalocean.com) droplet, Windows machine running [WSL](https://learn.microsoft.com/en-us/windows/wsl/), and deployment via [GitHub Actions](https://github.com/features/actions).

### Server

- [Initial setup](https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-20-04)
- [Docker setup](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)
- [Docker Compose setup](https://www.digitalocean.com/community/tutorials/how-to-install-docker-compose-on-ubuntu-20-04-quickstart)
- `docker network create nginx-proxy`
- Setup `dockeruser` for GitHub Actions

```bash
ssh dockeruser@$IP_ADDRESS
ssh-keygen
ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys2
chmod 700 ~/.ssh/authorized_keys && chmod 640 ~/.ssh/authorized_keys2
cat ~/.ssh/id_rsa
# Copy to GitHub secret DIGITAL_OCEAN_KEY
```

- Run `build-and-deploy.yml` GitHub Action with `domain` as `proxy`

### Local Setup

- [Install Ruby 2.7.0, Rails 5.2.4.4, and Node.js](https://gorails.com/setup)
- `sudo apt-get install -y imagemagick libmagickwand-dev`
- `gem install bundler:2.1.4`

### Add Site

- Create folder for new domain in `catdocker` repo
- Copy `docker-compose.yml`
- Copy `docker-compose.override.yml`
- Change values to match new domain

### Run SPA Locally

- Sync SPA source into a separate build folder:

```bash
# Run these commands from the catdocker root folder.
rm -rf ./biddy-spa-src
cp -a ../biddy-spa ./biddy-spa-src
rm -rf ./biddy-spa-src/.git ./biddy-spa-src/node_modules ./biddy-spa-src/dist
```

```bash
# Run these commands from the catdocker root folder.
docker network inspect nginx-proxy >/dev/null 2>&1 || docker network create nginx-proxy
docker compose -f proxy/docker-compose.yml up -d nginx-proxy
docker compose -f biddyonthebench/docker-compose.yml -f biddyonthebench/docker-compose.override.yml up --build -d
```

- Add a hosts entry on your machine:

```text
127.0.0.1 biddyonthebench.com www.biddyonthebench.com
```

- Windows (Git Bash as Administrator) add host entry:

```bash
echo "127.0.0.1 biddyonthebench.com www.biddyonthebench.com" >> /c/Windows/System32/drivers/etc/hosts
MSYS_NO_PATHCONV=1 /c/Windows/System32/ipconfig.exe /flushdns
```

- Windows (Git Bash as Administrator) remove host entry:

```bash
grep -v "biddyonthebench.com" /c/Windows/System32/drivers/etc/hosts > /tmp/hosts && cat /tmp/hosts > /c/Windows/System32/drivers/etc/hosts
MSYS_NO_PATHCONV=1 /c/Windows/System32/ipconfig.exe /flushdns
```

- Open `http://biddyonthebench.com`

- Stop local containers:

```bash
docker compose -f biddyonthebench/docker-compose.yml -f biddyonthebench/docker-compose.override.yml down
docker compose -f proxy/docker-compose.yml down
```

## Utilities

Random helpful scripts for server management.

### Restart Droplet

- Toggle on/off in DigitalOcean dashboard
- Run `build-and-deploy.yml` GitHub Action for each domain

```
proxy
annfleming
caseydyer
biddyonthebench
```

### Backup Site

```bash
ssh root@$IP_ADDRESS
docker container ls
docker cp $CONTAINER_NAME:/var/www backup
# Exit SSH
exit
cd ~/git
sudo scp -r root@143.110.147.142:backup backup
ssh root@$IP_ADDRESS
rm -rf backup
```

### Connect to Container

```bash
docker container ls
docker exec -it $CONTAINER_NAME bash
```

### View Container Logs

```bash
docker container ls
docker logs -f $CONTAINER_NAME
```

### Reset Docker

```bash
docker rm -vf $(docker ps -a -q)
docker rmi -f $(docker images -a -q)
docker volume prune
docker network prune
docker system prune
```

### Reset/Reconnect SSH

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

## Old Manual Steps

These steps were used before GitHub Actions were utilized.

### Build Site

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

### New Site Deployment

```bash
ssh root@$IP_ADDRESS
mkdir /home/dockeruser/$DOMAIN
scp docker-compose.yml root@$IP_ADDRESS:/home/dockeruser/$DOMAIN
docker-compose up -d
```

### Update Site

```bash
ssh root@$IP_ADDRESS
cd /home/dockeruser/$DOMAIN
# Pulls new image, recreates container, runs migrations
docker-compose pull && docker-compose up -d
```

### Restart Droplet

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
