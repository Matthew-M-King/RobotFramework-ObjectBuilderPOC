*** Settings ***
Documentation  SwagLabs Website Tests

Library         Dialogs
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

Scenario: Change Sort List Option to 1st option Name A to Z
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed for Default User
     When user selects 1st "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  NAME (A TO Z)          SortProducts
      And the "InventoryItemName" should be sorted low to high alphabetically

Scenario: Change Sort List Option to 2nd option Name Z to A
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed for Default User
     When user selects 2nd "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  NAME (Z TO A)          SortProducts
      And the "InventoryItemName" should be sorted high to low alphabetically

Scenario: Change Sort List Option to 3rd option Price High to Low
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed for Default User
     When user selects 3rd "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  PRICE (LOW TO HIGH)    SortProducts
      And the "InventoryItemPrices" should be sorted low to high numerical

Scenario: Change Sort List Option to last option Price High to Low
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed for Default User
     When user selects last "SortProducts" list option
     Then the following option should be selected in list:
          ^  Option                 List 
          >  PRICE (HIGH TO LOW)    SortProducts
      And the "InventoryItemPrices" should be sorted high to low numerical

Scenario: Add Items to Shopping Cart
    [Tags]  SwagLabs
    Given the "ProductsPage" page is displayed for Default User
     When user adds following number of products to basket: 3
     Then the "ShoppingCart" should display text: 3