#!/bin/bash -e

set -euo pipefail

[ ! -d "/var/run/sshd" ] && mkdir /var/run/sshd

[ ! -d ~/.ssh ] && mkdir ~/.ssh

chmod 700 ~/.ssh

[ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -A

cp /etc/ssh/sshd_config ~/.ssh/sshd_config

echo 'PermitRootLogin yes' >> ~/.ssh/sshd_config
echo 'PubkeyAuthentication no' >> ~/.ssh/sshd_config
echo 'PasswordAuthentication yes' >> ~/.ssh/sshd_config
echo 'UsePAM yes' >> ~/.ssh/sshd_config

echo 'session required pam_env.so envfile=/etc/environment' >> /etc/pam.d/sshd

chmod 600 ~/.ssh/sshd_config

echo "root:${SSH_PASSWORD}" | chpasswd

env > /etc/environment

exec /usr/sbin/sshd -f ~/.ssh/sshd_config -e -D