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

# install packages
ncu -u # upgrades all version refs in package.json
npm install

# create .env file, and populate with parameters
echo -e "\nPlease provide your SONAR_TOKEN"
read -s SONAR_TOKEN
echo "[secure]"
echo -e "\nPlease provide your SNYK_TOKEN"
read -s SNYK_TOKEN
echo "[secure]"

# clear existing .env file if it exists
if [ -f ".env" ]; then
  truncate -s 0 .env
fi

# enable Travis for the project
travis enable

# populate .env file with sonar-scanner properties
echo -e "SONAR_TOKEN=${SONAR_TOKEN}" >> .env
echo -e "SNYK_TOKEN=${SNYK_TOKEN}" >> .env
# populate travis.yml with sonar and snyk properties
yes | travis encrypt SONAR_TOKEN="${SONAR_TOKEN}" --add
yes | travis encrypt SNYK_TOKEN="${SNYK_TOKEN}" --add

echo -e "\nPlease provide your GitHub username:"
read GITHUB_USERNAME
echo -e "\nPlease provide your GitHub email address:"
read GITHUB_EMAIL

# commit the changes and push
git config user.name "${GITHUB_USERNAME}"
git config user.email "${GITHUB_EMAIL}"
git add .travis.yml package.json package-lock.json
git commit -m "build: setup new project files"
git push origin main
echo -e "\nChanges pushed to ${GITHUB_PROJECT}"

# open the repository with VS Code
code .
