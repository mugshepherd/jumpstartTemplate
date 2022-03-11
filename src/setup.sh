#!/bin/sh

echo "##################################################################################"
echo "WARNING: This script requires 'github cli', 'travis cli' and 'jq' to be installed."
echo "##################################################################################"

echo -e "\n💬 Please provide the name for the GitHub project you want to create:"
read GITHUB_PROJECT
echo -e "\n💬 Please provide a short description about the GitHub project you want to create:"
read GITHUB_DESCRIPTION
echo -e "\n💬 Please provide the template url:"
read GITHUB_TEMPLATE

echo -e "\nℹ️ Creating GitHub repository..."
gh repo create "${GITHUB_PROJECT}" --public --template="${GITHUB_TEMPLATE}" --clone
echo -e "\n✅ Repository created successfully!"

echo -e "\nℹ️ Checking out to main branch..."
cd "${GITHUB_PROJECT}"
git fetch
git checkout main
echo -e "\n✅ Checked out successfully!"

echo -e "\nℹ️ Syncing project with travis..."
travis sync
echo -e "\n✅ Synced successfully!"

echo -e "\nℹ️ Updating project name and description in package.json file..."
jq --arg name "${GITHUB_PROJECT}" '.name=$name' "package.json" > tmp && mv tmp "package.json"
jq --arg description "${GITHUB_DESCRIPTION}" '.description=$description' "package.json" > tmp && mv tmp "package.json"
rm -rf tmp
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Installing latest version of node packages..."
ncu -u # upgrades all version refs in package.json
npm install
echo -e "\n✅ Packages installed successfully!"

echo -e "\n💬 Please provide your SONAR_TOKEN"
read -s SONAR_TOKEN
echo "[secure]"
echo -e "\n💬 Please provide your SNYK_TOKEN"
read -s SNYK_TOKEN
echo "[secure]"

echo -e "\nℹ️ Enabling travis for the project..."
travis enable
echo -e "\n✅ Enabled successfully!"

echo -e "\nℹ️ Updating .nvmrc with latest node lts..."
nvm ls-remote --lts | tail -1 | grep -o -E '(\d+\.)(\d+\.)(\*|\d+)' > .nvmrc
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Updating .env file with environment variables..."
cat > .env << EOF
SONAR_TOKEN=${SONAR_TOKEN}
SNYK_TOKEN=${SNYK_TOKEN}
EOF
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Updating .travis.yml file with environment variables..."
yes | travis encrypt SONAR_TOKEN="${SONAR_TOKEN}" --add
yes | travis encrypt SNYK_TOKEN="${SNYK_TOKEN}" --add
echo -e "\n✅ File updated successfully!"

echo -e "\n💬 Please provide your GitHub username:"
read GITHUB_USERNAME
echo -e "\n💬 Please provide your GitHub email address:"
read GITHUB_EMAIL

echo -e "\nℹ️ Committing and pushing updated files to git..."
git config user.name "${GITHUB_USERNAME}"
git config user.email "${GITHUB_EMAIL}"
git add .nvmrc .travis.yml package.json package-lock.json
git commit -m "build: setup new project files"
git push origin main
echo -e "\n✅ Changes pushed successfully!"

echo -e "\n🚀 Project setup complete! Opening project in VS Code..."
code .
