#!/bin/sh

echo "################################################################"
echo "WARNING: This script requires 'jq' and 'travis' to be installed."
echo "################################################################"

echo -e "\nPlease provide your GitHub project name..."
read GITHUB_NAME
echo -e "\nPlease provide a short description about your project..."
read GITHUB_DESCRIPTION

echo -e "\nWould you like to setup SonarCloud? (Y/N)"
read SONAR_BOOL

if [ "${SONAR_BOOL}" = "Y" ]; then
  echo -e "\nPlease provide your SonarCloud organization name..."
  read SONAR_ORGANIZATION
  echo -e "\nPlease provide your SonarCloud project key..."
  read SONAR_PROJECT_KEY
  echo -e "\nPlease provide your SonarCloud project name..."
  read SONAR_PROJECT_NAME
  echo -e "\nPlease provide your SonarCloud token..."
  read -s SONAR_TOKEN
  echo "[secure]"
fi

echo -e "\nWould you like to setup Snyk? (Y/N)"
read SNYK_BOOL

if [ "${SNYK_BOOL}" = "Y" ]; then
  echo -e "\nPlease provide your Snyk token..."
  read -s SNYK_TOKEN
  echo "[secure]"
fi

if [ "${SONAR_BOOL}" = "Y" ] || [ "${SNYK_BOOL}" = "Y" ]; then
  echo -e "\nIs this project using travis.ibm.com? (Y/N)"
  read ENTERPRISE_BOOL

  echo -e "\nPlease provide your GitHub personal access token..."
  read -s GITHUB_TOKEN
  echo "[secure]"
fi

echo -e "\nProcessing user inputs, please wait..."

# upgrade package dependencies to latest versions
ncu -u

# login to travis cli
if [ "${SONAR_BOOL}" = "Y" ] || [ "${SNYK_BOOL}" = "Y" ]; then
  if [ "${ENTERPRISE_BOOL}" = "Y" ]; then
    travis endpoint --set-default -e "https://travis.ibm.com/api"
  else
    travis endpoint --set-default -e "https://api.travis-ci.com/"
  fi
  travis login -g "${GITHUB_TOKEN}"
fi

if [ "${SONAR_BOOL}" = "Y" ]; then
  # clear existing .env file if it exists
  if [ -f ".env" ]; then
    truncate -s 0 .env
  fi

  # populate .env file with sonar-scanner properties
  echo -e "SONAR_ORGANIZATION=${SONAR_ORGANIZATION}" >> .env
  echo -e "SONAR_PROJECT_KEY=${SONAR_PROJECT_KEY}" >> .env
  echo -e "SONAR_TOKEN=${SONAR_TOKEN}" >> .env
  # populate travis.yml with sonar-scanner properties
  yes | travis encrypt SONAR_ORGANIZATION="${SONAR_ORGANIZATION}" --add
  yes | travis encrypt SONAR_PROJECT_KEY="${SONAR_PROJECT_KEY}" --add
  yes | travis encrypt SONAR_PROJECT_NAME="${SONAR_PROJECT_NAME}" --add
  yes | travis encrypt SONAR_TOKEN="${SONAR_TOKEN}" --add
fi

if [ "${SNYK_BOOL}" = "Y" ]; then
  yes | travis encrypt SNYK_TOKEN="${SNYK_TOKEN}" --add
fi

# package.json & package-lock.json
jq --arg name "${GITHUB_NAME}" '.name=$name' "package.json" > tmp && mv tmp "package.json"
jq --arg name "${GITHUB_NAME}" '.name=$name' "package-lock.json" > tmp && mv tmp "package-lock.json"
jq --arg description "${GITHUB_DESCRIPTION}" '.description=$description' "package.json" > tmp && mv tmp "package.json"
rm -rf tmp

echo -e "\nProcessing complete, thank you for waiting."
