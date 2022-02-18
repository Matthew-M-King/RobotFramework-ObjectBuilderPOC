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

PO: Input: Await And Click Link
    [Arguments]  ${target_element}
    ${locator}  Build Locator  ${target_element}
    Wait Until Element Is Visible  ${locator}
    Click Link  ${locator}

PO: Input: Await And Click X Number Of Buttons
    [Arguments]  ${target_elements}  ${amount}
    ${locator}  Build Locator  ${target_elements}
    Wait Until Element Is Visible  ${locator}
    ${locators}  Get WebElements   ${locator}
    
    ${index}  <-  ${0}
    FOR  ${element}  IN  @{locators}
        Click Button  ${element}
        ${index}  Evaluate  ${index}+1
        Exit For Loop IF  ${index}==${amount}
    END