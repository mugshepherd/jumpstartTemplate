#!/bin/sh

Describe 'dummy.sh'
  Include lib/dummy.sh
  It 'should say Hello World'
    When call hello World
    The output should equal "Hello World!"
  End
End
