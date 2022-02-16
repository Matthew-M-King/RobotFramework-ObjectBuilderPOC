*** Settings ***
Documentation  Setup Tests

Library   SeleniumLibrary
Resource  Settings/_Settings.robot
Resource  Utility/ShorthandUtility.robot
Resource  PO/_Keywords/Pages/LoginPagePO.robot

*** Keywords ***
Begin Suite
    Open Browser  ${SiteUrls.${target_app}}  ${browser}
    Maximize Browser Window

Begin Suite With ${user_type} User
    Begin Suite
    Login App  ${user_type}
    
Teardown Suite
    Close Browser