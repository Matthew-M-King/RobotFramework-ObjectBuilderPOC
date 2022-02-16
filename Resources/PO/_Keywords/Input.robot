*** Settings ***
Library  SeleniumLibrary
Library  String

Resource  Common.robot

*** Keywords ***
PO: Input: Await And Input Text
    [Arguments]  ${target_element}  ${text}
    ${locator}  Build Locator  ${target_element}
    Wait Until Element Is Visible  ${locator}
    Input Text  ${locator}  ${text}

PO: Input: Await And Click Button
    [Arguments]  ${target_element}
    ${locator}  Build Locator  ${target_element}
    Wait Until Element Is Visible  ${locator}
    Click Button  ${locator}