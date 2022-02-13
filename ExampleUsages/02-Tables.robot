*** Settings ***
Documentation  Calculator
...
...            As a user
...            I want to use a calculator to add numbers
...            So that I don't need to add myself

Resource  ../Utility/02-TablesUtility.robot

*** Test Cases ***
Scenario: Add two numbers
    Given I have a calculator
     When I add the following numbers
          ^  num1    num2
          >  -2      3
          >  10      15
          >  -1      -10
     Then the totals of calculations should be:
          >  1
          >  25
          >  -11