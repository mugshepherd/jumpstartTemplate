#!/bin/sh

Mock sonar-scanner
  for word in "$@"; do echo $word; done
End 

Describe 'sonarcloud.sh'
  Include lib/sonarcloud.sh
  It 'should call sonar-scanner with the correct parameters on a pull request'
    TRAVIS_EVENT_TYPE="pull_request"
    When call sonarscanner
    The output should include "sonar.organization"
    The output should include "sonar.login"
    The output should include "sonar.projectKey"
    The output should include "sonar.pullrequest.key"
    The output should include "sonar.pullrequest.branch"
    The output should include "sonar.pullrequest.base"
    The output should not include "sonar.branch.name"
  End

  It 'should call sonar-scanner with the correct parameters on a push'
    TRAVIS_EVENT_TYPE="push"
    When call sonarscanner
    The output should include "sonar.organization"
    The output should include "sonar.login"
    The output should include "sonar.projectKey"
    The output should include "sonar.branch.name"
    The output should not include "sonar.pullrequest.key"
    The output should not include "sonar.pullrequest.branch"
    The output should not include "sonar.pullrequest.base"
  End
End
