#!/bin/sh

echo -e "\nℹ️ Installing latest version of node packages..."
npm ci
npx npm-check-updates --upgrade
npm i
git add package.json package-lock.json
echo -e "\n✅ Packages installed successfully!"

echo -e "\nℹ️ Updating .nvmrc with latest node lts..."
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # loads nvm
nvm install --lts
NODE_VERSION=$(nvm version)
echo "${NODE_VERSION}" > .nvmrc
git add .nvmrc
echo -e "\n✅ File updated successfully!"

echo -e "\n🚀 Project maintenance complete! Please review and commit your changes."
