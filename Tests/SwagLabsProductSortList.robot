*** Settings ***
Documentation  SwagLabs Product Sort List

Resource        _Resources.robot
Suite Setup     Begin Suite
Suite Teardown  Teardown Suite

*** Test Cases ***
Scenario: Change Sort List Option
    [Tags]  SwagLabs
    Given the "Products" page is displayed for Default User
     When user selects last "SortProducts" list option
    