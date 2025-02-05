#!/bin/bash -e

set -euo pipefail

mkdir /var/run/sshd

# Create the SSH directory
mkdir ~/.ssh
chmod 700 ~/.ssh

# Generate SSH host keys
ssh-keygen -A

# Configure the SSH server
cp /etc/ssh/sshd_config ~/.ssh/sshd_config

# Modify SSH configuration for password authentication
echo 'PermitRootLogin yes' >> ~/.ssh/sshd_config
echo 'PubkeyAuthentication no' >> ~/.ssh/sshd_config
echo 'PasswordAuthentication yes' >> ~/.ssh/sshd_config
echo 'UsePAM yes' >> ~/.ssh/sshd_config

echo 'session required pam_env.so envfile=/etc/environment' >> /etc/pam.d/sshd

chmod 600 ~/.ssh/sshd_config

# Set a password for the root user
echo "root:${SSH_PASSWORD}" | chpasswd

env > /etc/environment

exec /usr/sbin/sshd -f ~/.ssh/sshd_config -e -D