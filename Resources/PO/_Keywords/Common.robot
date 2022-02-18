*** Settings ***
Library    Collections
Library    SeleniumLibrary
Resource   _ObjectBuilder.robot

*** Keywords ***
PO: Common: Get Texts
    [Documentation]    Get list of text from multiple web elements
    [Arguments]    ${target_element}
    ${locator}  Build Locator  ${target_element}
    @{elements}    Get WebElements    ${locator}
    @{element_text_list}    Create List
    FOR    ${element}    IN    @{elements}
        ${element_text}    Get Text    ${element}
        Append To List    ${element_text_list}    ${element_text}
    END
    [Return]    ${element_text_list}

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

PO: Common: Await And Assert Element Text
    [Arguments]  ${target_element}  ${text}
    ${locator}  Build Locator  ${target_element}
    Wait Until Element Is Visible  ${locator}
    Element Text Should Be  ${locator}  ${text}

PO: Common: Assert Element Group Sort Order  
    [Arguments]  ${target_elements}  ${order} 
    ${order}  Convert To Lower Case  ${order}
    
    ${texts}  PO: Common: Get Texts  ${target_elements}          
    @{actual_list}  Create List
    
    IF  "numerical" in "${order}"
        FOR  ${text}  IN  @{texts}  
            ${match}  <-  ${NONE}
            ${matches}  Get Regexp Matches  ${text}  \\d+
            IF  ${matches}
                ${values}  <-  ${EMPTY}
                FOR  ${value}  IN  @{matches}
                    ${values}  Catenate  ${values}${value}
                END
                ${values}  Convert To Integer  ${values}
            END 
            Append To List   ${actual_list}  ${values} 
        END
        ${expected_list}  Copy List  ${actual_list}
        Sort List  ${expected_list}

        IF  "hightolow" in "${order}" 
            Reverse List    ${expected_list}
            Lists Should Be Equal  ${actual_list}  ${expected_list}
        ELSE 
            Lists Should Be Equal  ${actual_list}  ${expected_list}
        END
    
    ELSE
        ${actual_list}  <-  ${texts}
        ${expected_list}  Copy List  ${actual_list}

        Sort List  ${expected_list}

        IF  "hightolow" in "${order}" 
            Reverse List    ${expected_list}
            Lists Should Be Equal  ${actual_list}  ${expected_list}
        ELSE 
            Lists Should Be Equal  ${actual_list}  ${expected_list}
        END

    END
        

    