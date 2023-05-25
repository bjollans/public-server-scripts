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

cat .creds.json | jq -r '.GithubSSH' > ~/.ssh/github_read_only
chmod 400 ~/.ssh/github_read_only
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/github_read_only
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone $URL