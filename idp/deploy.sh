#!/bin/bash

CERTS_PATH="/root/wba-openroamin-connector/certs"

if [ "$EUID" -ne 0 ]
  then echo "You must run this script as root, you can either sudo the script directly or become root with a command such as 'sudo su'"
  exit
fi

if [[ ! -f "$CERTS_PATH/freeradius/cert.pem" ]]
then
    echo "Please upload your FreeRadius (LetsEncrypt) certificate to $CERTS_PATH/freeradius/cert.pem"
    exit 1
fi
if [[ ! -f "$CERTS_PATH/freeradius/privkey.pem" ]]
then
    echo "Please upload your FreeRadius (LetsEncrypt) private key to $CERTS_PATH/freeradius/privkey.pem"
    exit 1
fi

# Prompt for MySQL root password
read -p "Enter MySQL root password [admin]: " MYSQL_ROOT_PASSWORD
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-admin}

# Prompt for MySQL user name
read -p "Enter MySQL user name [admin]: " MYSQL_USER
MYSQL_USER=${MYSQL_USER:-admin}

# Prompt for MySQL password
read -p "Enter MySQL password [admin]: " MYSQL_PASSWORD
MYSQL_PASSWORD=${MYSQL_PASSWORD:-admin}

# Save the values to a .env file
cat > .env <<EOL
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}
MYSQL_USER=${MYSQL_USER}
MYSQL_PASSWORD=${MYSQL_PASSWORD}
EOL

# Replace placeholders in the sql file
sed -i "s/-RSQLUSER-/${MYSQL_USER}/g" /root/wba-openroaming-connector/idp/configs/freeradius/mods-available/sql
sed -i "s/-RSQLPASS-/${MYSQL_PASSWORD}/g" /root/wba-openroaming-connector/idp/configs/freeradius/mods-available/sql

# Install dependencies
apt-get update -y
apt-get install curl wget nano git python3 python3-pip -y

if ! command -v docker &> /dev/null
then
    # Install Docker
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
else
    echo "Docker is already installed. Skipping installation."
fi

sudo apt install docker-compose-plugin -y

#Prepare the environment
cd /root
#Prepare FreeRADIUS Certs
cp $CERTS_PATH/freeradius/*.pem /root/wba-openroaming-connector/idp/configs/freeradius/certs
# ready workdir
cd /root/wba-openroaming-connector/idp/
docker compose up -d
