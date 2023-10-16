#!/bin/bash

# Install git and python3
sudo apt-get update
sudo apt-get install -y git python3-venv python3-pip

# Clone GOAD repository and activate the virtual environment
git clone --branch aws https://github.com/jedha-github/GOAD.git /home/ubuntu/GOAD
cd /home/ubuntu/GOAD/ansible
python3 -m venv .venv
source .venv/bin/activate

# Install ansible and pywinrm
python3 -m pip install --upgrade pip
python3 -m pip install ansible-core==2.12.6
python3 -m pip install pywinrm

# Install the required ansible libraries
ansible-galaxy install -r requirements.yml

# Install AWS CLI v2
# cd /home/ubuntu
# sudo apt install unzip -y
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# rm -rf awscliv2.zip aws
