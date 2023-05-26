#!/bin/bash

URL=$1
shift
BRANCH=$1
shift

check_argument() {
    if [[ -z "$1" ]]; then
        help_and_exit
    fi
}

help_and_exit() {
    echo "Usage: $0 <url> <branch>"
    echo "This script takes two argument, namely the github repo you want to clone and the branch you want to checkout"
    echo "Example: $0 git@github.com:bjollans/laralabs-automation.git main"
}

#If either the URL or the branch is empty, exit
if [[ -z "$URL" ]]; then
    help_and_exit
fi

if [[ -z "$BRANCH" ]]; then
    help_and_exit
fi

if [[ ! -f .creds.json ]]; then
    echo "No '.creds.json' file found. Exiting"
    exit 1
fi

echo "Setting up dependencies"
./install_basics.sh

cat .creds.json | jq -r '.GithubSSH' > github_read_only_key
chmod 400 github_read_only_key
eval "$(ssh-agent -s)"
ssh-add github_read_only_key
ssh-keyscan github.com >> ~/.ssh/known_hosts
git clone $URL
cd $(echo $URL | sed 's|.*/||;s|.git||')
git checkout $BRANCH
cd -
rm github_read_only_key
