#!/bin/sh

echo "WARNING: This script requires 'github cli' to be installed."

echo -e "\nPlease provide the name for the GitHub project you want to create:"
read GITHUB_PROJECT
echo -e "\nPlease provide the template url:"
read GITHUB_TEMPLATE

gh repo create "${GITHUB_PROJECT}" --public --template="${GITHUB_TEMPLATE}" --clone

cd "${GITHUB_PROJECT}"
git fetch
git checkout main
