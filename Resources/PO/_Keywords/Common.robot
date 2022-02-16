*** Settings ***
Library    Collections
Library    SeleniumLibrary
Resource   _ObjectBuilder.robot

*** Keywords ***
PO: Common: Get Expected Locator Text
    [Documentation]  Gets a list of text values expected within the target element from the Definitions files
    [Arguments]  ${target_element}  ${page}=${NONE}
    ${page}  ??  ${page}   PO: Page: Get
    Run Keyword And Return  <-   ${${page}_Definitions.${target_element}.ShouldContain}

PO: Common: Locators Should Contain Values
    ${page}  PO: Page: Get
    ${dicts}  <-  ${${page}_Definitions}
    FOR  ${target_element}  IN  @{dicts.keys()}
        Key->  ${dicts}[${target_element}]   ShouldContain  PO: Common: Locator Should Contain Value  ${target_element}
    END

PO: Common: Locator Should Contain Value
    [Arguments]  ${target_element}
    ${locator}  Build Locator  ${target_element}
    ${actual_text}  Get Text  ${locator} 
    ${expected_text}  PO: Common: Get Expected Locator Text   ${target_element}
    FOR  ${text}  IN  @{expected_text}
        Should Contain  ${actual_text}  ${text}
    END

PO: Common: Assert Current Page Elements
    ${current_page}  PO: Page: Get
    ${definitions}  <-  ${${current_page}_Definitions}
    FOR  ${target_element}  IN  @{definitions.keys()}
        PO: Common: Assert Main Element Counts  ${definitions}   ${target_element}
    END
    
PO: Common: Assert Main Element Counts
    [Arguments]  ${definitions}  ${target_element}  
    ${is_key}  Is Key?  ${definitions}[${target_element}]  ElementCountShouldBe
    Return From Keyword If  not ${is_key}
    ${locator}  Build Locator  ${target_element}
    ${count}  <-  ${definitions}[${target_element}][ElementCountShouldBe]
    Page Should Contain Element  ${locator}  limit=${count}