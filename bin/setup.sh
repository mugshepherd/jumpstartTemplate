#!/bin/sh

echo "########################################################################################"
echo "WARNING: This script requires 'github cli', 'travis cli', 'yq' and 'jq' to be installed."
echo "########################################################################################"

echo -e "\n💬 Please provide the template url:"
read GITHUB_TEMPLATE
echo -e "\n💬 Please provide the name for the GitHub project you want to create:"
read GITHUB_PROJECT
echo -e "\n💬 Please provide a short description about the GitHub project you want to create:"
read GITHUB_DESCRIPTION

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

echo -e "\n💬 Please provide your SonarCloud organization name"
read SONAR_ORGANIZATION
echo -e "\n💬 Please provide your SonarCloud project key"
read SONAR_PROJECT_KEY
echo -e "\n💬 Please provide your SONAR_TOKEN"
read -s SONAR_TOKEN
echo "[secure]"
echo -e "\n💬 Please provide your SNYK_TOKEN"
read -s SNYK_TOKEN
echo "[secure]"

echo -e "\nℹ️ Creating project in SonarCloud..."
curl --include \
  --request POST \
  --header "Content-Type: application/x-www-form-urlencoded" \
  -u ${SONAR_TOKEN}: \
  -d "project=${SONAR_PROJECT_KEY}&organization=${SONAR_ORGANIZATION}&name=${SONAR_PROJECT_KEY}" \
  'https://sonarcloud.io/api/projects/create'
echo -e "\n✅ Project created successfully!"

echo -e "\nℹ️ Setting leak period in SonarCloud..."
curl --location --include \
  --request POST \
  --header "Content-Type: application/x-www-form-urlencoded" \
  -u ${SONAR_TOKEN}: \
  -d "key=sonar.leak.period&value=previous_version&component=${SONAR_PROJECT_KEY}" \
  'https://sonarcloud.io/api/settings/set'
echo -e "\n✅ Leak period set successfully!"

echo -e "\nℹ️ Setting leak period type in SonarCloud..."
curl --location --include \
  --request POST \
  --header "Content-Type: application/x-www-form-urlencoded" \
  -u ${SONAR_TOKEN}: \
  -d "key=sonar.leak.period.type&value=previous_version&component=${SONAR_PROJECT_KEY}" \
  'https://sonarcloud.io/api/settings/set'
echo -e "\n✅ Leak period type set successfully!"

echo -e "\nℹ️ Enabling travis for the project..."
yes | travis enable
echo -e "\n✅ Enabled successfully!"

echo -e "\nℹ️ Updating .env file with environment variables..."
cat > .env << EOF
SONAR_ORGANIZATION=${SONAR_ORGANIZATION}
SONAR_PROJECT_KEY=${SONAR_PROJECT_KEY}
SONAR_TOKEN=${SONAR_TOKEN}
SNYK_TOKEN=${SNYK_TOKEN}
EOF
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Updating package.json file with project name and description..."
jq --arg name "${GITHUB_PROJECT}" '.name=$name' "package.json" > tmp && mv tmp "package.json"
jq --arg description "${GITHUB_DESCRIPTION}" '.description=$description' "package.json" > tmp && mv tmp "package.json"
rm -rf tmp
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Updating .travis.yml file with environment variables..."
yq -Y .env.global.SONAR_ORGANIZATION="${SONAR_ORGANIZATION}" .travis.yml > tmp && mv tmp .travis.yml
yq -Y .env.global.SONAR_PROJECT_KEY="${SONAR_PROJECT_KEY}" .travis.yml > tmp && mv tmp .travis.yml
yes | travis encrypt SONAR_TOKEN="${SONAR_TOKEN}" --add
yes | travis encrypt SNYK_TOKEN="${SNYK_TOKEN}" --add
rm -rf tmp
git add .travis.yml
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Installing latest version of node packages..."
npx ncu -u # upgrades all version refs in package.json
npm install
git add package.json package-lock.json
echo -e "\n✅ Packages installed successfully!"

echo -e "\nℹ️ Updating .nvmrc with latest node lts..."
nvm install --lts
NODE_VERSION=$(nvm version)
echo "${NODE_VERSION}" > .nvmrc
git add .nvmrc
echo -e "\n✅ File updated successfully!"

echo -e "\nℹ️ Updating .secrets.baseline to prevent new secrets being added..."
npm run detect-secrets:update-baseline
git add .secrets.baseline
echo -e "\n✅ File updated successfully!"

echo -e "\n💬 Please provide your GitHub username:"
read GITHUB_USERNAME
echo -e "\n💬 Please provide your GitHub email address:"
read GITHUB_EMAIL

echo -e "\nℹ️ Committing and pushing updated files to git..."
git config user.name "${GITHUB_USERNAME}"
git config user.email "${GITHUB_EMAIL}"
git commit -m "build: setup new project repository"
git push origin main
echo -e "\n✅ Changes pushed successfully!"

echo -e "\n🚀 Project setup complete! Opening project in VS Code..."
code .
