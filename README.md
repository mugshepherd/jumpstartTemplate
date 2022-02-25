# node-starter

This is a template repository for use with nodejs projects.

## Getting started

### Pre-requisites

- node (verify you have it installed with `node --version`, should be latest [LTS branch](https://nodejs.org/en/))
- npm (verify you have it installed with `npm --version`)
- nvm (verify you have it installed with `nvm --version`)
- IBM GitHub ssh key should be set, so you can clone repositories with the `git clone` command [https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh](https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh)

### Create the repository

```
gh repo create test-kata-template --public --template="https://github.ibm.com/Alexander-Skelding/node-starter"
```

### Clone the repository

```
git clone git@github.ibm.com:[organization]/[project].git
```

### Change your current directory

```
cd [project]
```

### Install and use the project node version

`nvm install`

### Install node dependencies

`npm ci`

## Setting up Travis and SonarCloud

### Install the bash script dependencies

```
brew install jq
```

```
brew install travis
```

### Create a new project in SonarCloud

Navigate to: https://sonarcloud.io/projects/create

Create a project manually and make note of the Organization, Project key, Display name.

Choose the analysis method of 'Travis CI' and make note of the SONAR_TOKEN.

### Obtain your Snyk auth credentials

Navigate to: https://app.snyk.io/account

Click to show your auth token key and make note of this.

### Run the setup script

```
bash scripts/setup.sh
```

When prompted, input the project information.

### Enable Travis for your repository

Navigate to: https://travis.ibm.com/profile

Flick the repository switch on your project.

### Commit and push your local changes

```
git add .travis.yml package.json package-lock.json
```

```
git commit -m 'build: executed the setup.sh script to setup the project'
```

```
git push origin main
```
