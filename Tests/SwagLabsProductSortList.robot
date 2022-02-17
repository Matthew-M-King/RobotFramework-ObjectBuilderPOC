*** Settings ***
Documentation  SwagLabs Product Sort List

Resource        _Resources.robot
Suite Setup     Begin Suite
Suite Teardown  Teardown Suite

*** Test Cases ***
Scenario: Change Sort List Option to 1st option Name A to Z
    [Tags]  SwagLabs
    Given the "Products" page is displayed for Default User
     When user selects 1st "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  NAME (A TO Z)          SortProducts
      And the "InventoryItemName" should be sorted low to high alphabetically

Scenario: Change Sort List Option to 2nd option Name Z to A
    [Tags]  SwagLabs
    Given the "Products" page is displayed for Default User
     When user selects 2nd "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  NAME (Z TO A)          SortProducts
      And the "InventoryItemName" should be sorted high to low alphabetically

Scenario: Change Sort List Option to 3rd option Price High to Low
    [Tags]  SwagLabs
    Given the "Products" page is displayed for Default User
     When user selects 3rd "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  PRICE (LOW TO HIGH)    SortProducts
      And the "InventoryItemPrices" should be sorted low to high numerical

Scenario: Change Sort List Option to last option Price High to Low
    [Tags]  SwagLabs
    Given the "Products" page is displayed for Default User
     When user selects last "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  PRICE (HIGH TO LOW)    SortProducts
      And the "InventoryItemPrices" should be sorted high to low numerical

