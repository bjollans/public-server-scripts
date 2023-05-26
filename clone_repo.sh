#!/bin/bash

URL=$1

if [[ -z $URL ]]; then
    echo "This script takes a single argument, namely the github repo you want to clone. No URL provided. Exiting"
    exit 1
fi

if [[ ! -f .creds.json ]]; then
    echo "No '.creds.json' file found. Exiting"
    exit 1
fi

cat .creds.json | jq -r '.GithubSSH' > github_read_only_key
chmod 400 github_read_only_key
eval "$(ssh-agent -s)"
ssh-add github_read_only_key
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone $URL
