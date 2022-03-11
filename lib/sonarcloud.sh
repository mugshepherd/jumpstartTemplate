#!/bin/bash

sonarscanner() {
  if [ "${TRAVIS_EVENT_TYPE}" = "pull_request" ]; then
    sonar-scanner -D sonar.organization="${SONAR_ORGANIZATION}" -D sonar.login="${SONAR_TOKEN}" -D sonar.projectKey="${SONAR_PROJECT_KEY}" -D sonar.pullrequest.key="${TRAVIS_PULL_REQUEST}" -D sonar.pullrequest.branch="${TRAVIS_PULL_REQUEST_BRANCH}" -D sonar.pullrequest.base="${TRAVIS_BRANCH}"
  elif [ "${TRAVIS_EVENT_TYPE}" = "push" ]; then
    sonar-scanner -D sonar.organization="${SONAR_ORGANIZATION}" -D sonar.login="${SONAR_TOKEN}" -D sonar.projectKey="${SONAR_PROJECT_KEY}" -D sonar.branch.name="${TRAVIS_BRANCH}"
  fi
}
