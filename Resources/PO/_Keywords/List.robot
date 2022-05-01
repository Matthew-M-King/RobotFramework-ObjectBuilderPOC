*** Settings ***
Library     SeleniumLibrary
Library     String
Resource    Common.robot


*** Variables ***
${option_placeholder}       //option[{0}]


*** Keywords ***
PO: List: Select Option At Position
    [Arguments]    ${target_element}    ${position}
    IF    "${position}"=="last"
        ${position}    Set Variable    last()
    END
    ${locator}    Build Locator    ${target_element}    extension=//option[${position}]
    Wait Until Element Is Visible    ${locator}
    Click Element    ${locator}

PO: List: Assert Active Option
    [Arguments]    ${target_element}    ${value}    ${target_element_suffix}=ActiveOption
    ${target_element}    <-    ${target_element}${target_element_suffix}
    ${locator}    Build Locator    ${target_element}
    ${active_option}    Get Text    ${locator}
    Should Be Equal As Strings    ${active_option}    ${value}
