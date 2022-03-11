# Checklist

- [x] gh repo create command (using your template repo as the template)
- [x] accept an input parameter of the name of the repository
- [x] pull the code down locally
- [x] checkout the main branch
- [x] Sync your project with Travis (nothing to be done for Github actions)
- [x] swap the old project name with the new one
- [x] install the packages (maybe update old packages)
- [x] create the .env file with the SONAR_TOKEN and SNYK_TOKEN
- [x] Enable Travis for the project (nothing to be done for Github actions)
- [x] add SONAR_TOKEN and SNYK_TOKEN securely to your pipeline
- [x] Commit the changes and push
- [x] Open the repository with VS Code
- [x] Add echo statements for each stage
- [x] Automatically update .nvmrc
- [x] Adding SONAR_ORGANIZATION, SONAR_PROJECT_KEY to enable sonar for the project
- [x] Re-order commands for more logical flow
- [x] Create project in Snyk
- [x] Create project in SonarCloud
- [x] Set new code quality gate to 'previous version'
- [x] Update secrets.basline
- [ ] add validation for bash script
- [ ] add note to readme that user should run script in directory where they want to create project.
- [ ] include option to install dependencies (e.g. gh cli) if it's not already present
- [ ] Add validation to ensure dependencies are installed
- [ ] Add a way to differential secure global travis env vars
- [ ] Providing an option to the user for installing SNYK and SONAR
- [ ] Providing support for both GHE and GH Public when creating a project
- [ ] Add Snyk, Travis and GitHub badges to readme
- [ ] Create SONAR_TOKEN for project through cli?
- [ ] Retrieve SNYK_TOKEN through cli?

Bug 1
ℹ️ Updating .travis.yml file with environment variables...
jq: error: alexander/0 is not defined at <top-level>, line 1:
.env.global.SONAR_ORGANIZATION=alexander-skelding  
jq: error: skelding/0 is not defined at <top-level>, line 1:
.env.global.SONAR_ORGANIZATION=alexander-skelding  
jq: 2 compile errors
jq: error: jumpstart/0 is not defined at <top-level>, line 1:
.env.global.SONAR_PROJECT_KEY=jumpstart-test-1  
jq: error: test/0 is not defined at <top-level>, line 1:
.env.global.SONAR_PROJECT_KEY=jumpstart-test-1  
jq: 2 compile errors

Bug 2
ℹ️ Installing latest version of node packages...
Need to install the following packages:
ncu
Ok to proceed? (y) y

Bug 3
ℹ️ Updating .nvmrc with latest node lts...
node-starter-jumpstart/bin/setup.sh: line 102: nvm: command not found
node-starter-jumpstart/bin/setup.sh: line 103: nvm: command not found

Bug 4
ERROR: Error during SonarScanner execution
ERROR: QUALITY GATE STATUS: FAILED - View details on https://sonarcloud.io/dashboard?id=jumpstart-test-1
ERROR:
husky - pre-push hook exited with code 2 (error)
error: failed to push some refs to 'github.ibm.com:Alexander-Skelding/jumpstart-test-1.git'
