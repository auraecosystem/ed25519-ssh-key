#!/bin/bash

# generate new personal ed25519 ssh key
ssh-keygen -o -a 100 -t ed25519 -f ~/.ssh/id_ed25519 -C "rob thijssen <rthijssen@gmail.com>"

# generate new host cert authority (host_ca) ed25519 ssh key
# used for signing host keys and creating host certs
ssh-keygen -t ed25519 -f manta_host_ca -C manta.network

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# set local file permissions
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 644 ~/.ssh/known_hosts
chmod 644 ~/.ssh/config
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub

# add key to git/github
git config --global core.sshCommand "ssh -i ~/.ssh/id_ed25519 -F /dev/null"
# sudo dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo
# sudo dnf install gh
gh ssh-key add ~/.ssh/id_ed25519.pub
