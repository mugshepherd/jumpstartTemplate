#!/bin/sh

echo "############################################################################"
echo "WARNING: This script requires 'github cli' and 'travis cli' to be installed."
echo "############################################################################"

echo -e "\nPlease provide the name for the GitHub project you want to create:"
read GITHUB_PROJECT
echo -e "\nPlease provide the template url:"
read GITHUB_TEMPLATE

# gh repo create command, accept the name of the repository & pull the code down locally
gh repo create "${GITHUB_PROJECT}" --public --template="${GITHUB_TEMPLATE}" --clone

# checkout the main branch
cd "${GITHUB_PROJECT}"
git fetch
git checkout main

# sync your project with Travis
travis sync
