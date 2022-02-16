*** Settings ***
Documentation  SwagLabs Page Verify

Resource        _Resources.robot
Suite Setup     Begin Suite
Suite Teardown  Teardown Suite

*** Test Cases ***
Scenario: Assert Login Page
    [Tags]  SwagLabs
    Given the "LoginPage" page is displayed
     When user views elements of the current page
     Then the current page should contain correct elements
      And elements on current page should contain correct values
    
Scenario: Assert Products Page
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed
     When user views elements of the current page
     Then the current page should contain correct elements
      And elements on current page should contain correct values

Scenario: Assert Products Page With Performance Glitched User
    [Tags]  Swaglabs
    Given the "ProductsPage" page is displayed for Glitched user
     When user views elements of the current page
     Then the current page should contain correct elements
      And elements on current page should contain correct values