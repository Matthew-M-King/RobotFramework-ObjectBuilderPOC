*** Settings ***
Library   SeleniumLibrary
Library   String
Resource  Common.robot

*** Variables ***
${option_placeholder}  //option[{0}]

*** Keywords ***
PO: List: Select Option At Position
    [Arguments]  ${target_element}  ${position}
    ${position}  Run Keyword If  "${position}"=="last"  Set Variable  last()  ELSE  Set Variable  ${position}
    ${locator}   Build Locator  ${target_element}  extension=//option[${position}]
    Wait Until Element Is Visible  ${locator}
    Click Element  ${locator}