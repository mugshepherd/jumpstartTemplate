#!/bin/sh

echo "##################################################################################"
echo "WARNING: This script requires 'github cli', 'travis cli' and 'jq' to be installed."
echo "##################################################################################"

echo -e "\nPlease provide the name for the GitHub project you want to create:"
read GITHUB_PROJECT
echo -e "\nPlease provide a short description about the GitHub project you want to create:"
read GITHUB_DESCRIPTION
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

# swap the old project name with the new one
jq --arg name "${GITHUB_PROJECT}" '.name=$name' "package.json" > tmp && mv tmp "package.json"
jq --arg description "${GITHUB_DESCRIPTION}" '.description=$description' "package.json" > tmp && mv tmp "package.json"
rm -rf tmp
