*** Settings ***
Resource   ../PageRegistry/_${target_app}Variables.robot
Library    Collections

*** Keywords ***
Build Locator
    [Documentation]  Build locator based on locator definition yaml files and supported locator strategies:
    ...   ParentReferenceWithXpathLookup
    ...   ParentReferenceWithType
    ...   ParentReferenceWithAttribute
    ...   ParentReferenceWithText
    ...   XPathLookup
    ...   WithAttribute
    ...   WithText
    [Arguments]  ${target_element}  ${extension}=${EMPTY}  ${page}=${NONE}
    
    # Get the current page as we will use it in the yaml lookup
    ${page}  ??  ${page}   PO: Page: Get
    ${properties}  <-   ${${page}_Objects.${target_element}}
    
    ${is_parent_ref}   Run Keyword And Return Status  Should Contain  ${properties.LocatorStrategy}  ParentReference
    IF  ${is_parent_ref}
        ${locator_strategy}  <-  ParentReference
    ELSE 
        ${locator_strategy}  <-  ${properties.LocatorStrategy}
    END

    # Decide locator strategy to build based on yaml properties and run keyword
    Run Keyword And Return  Run Keyword  Build Locator: ${locator_strategy}   ${properties}  ${page}  ${extension}
    [Return]   ${locator}
    
Build Locator: ParentReference
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${child_locator_strategy}  Remove String  ${properties.LocatorStrategy}   ParentReference
    ${parent_reference}   <-   ${properties.ParentReference}
    ${parent_locator}  Build Locator  ${parent_reference}
    ${locator}  Run Keyword  Build Locator: ${child_locator_strategy}  ${properties}  ${page}  ${extension}
    Run Keyword And Return  <-  ${parent_locator}${locator}

Build Locator: XPathLookUp
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    Run Keyword And Return  <-  ${properties.Xpath}

Build Locator: WithType
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${type}        <-   ${properties.ElementType}
    Run Keyword And Return  <-  //${type}

Build Locator: WithAttribute
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${attribute}   <-   ${properties.Attribute}
    ${name}        <-   ${properties.Name}
    ${type}        <-   ${properties.ElementType}
    Run Keyword And Return  <-  //${type}\[@${attribute}="${name}"]${extension}

Build Locator: WithText
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${text}  <-  ${properties.Text}
    ${type}  <-  ${properties.ElementType}
    Run Keyword And Return  <-  //${type}\[normalize-space()="${text}"]${extension}

Build Locator: WithContainsAttribute
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${attribute}            <-   ${properties.Attribute}
    ${name}                 <-   ${properties.Name}
    Run Keyword And Return  <-  //${properties.ElementType}\[contains(@${attribute}, "${name}"]${extension}

Build Locators
    @{locators}  Create List
    ${page}  PO: Page: Get
    ${dicts}  <-  ${${page}_Objects}
    FOR  ${target_element}  IN  @{dicts.keys()}
        &{locator_details}  Create Dictionary
        ${locator}  Build Locator  ${target_element}
        Set To Dictionary  ${locator_details}   Name=${target_element}  Locator=${locator}  ${target_element}=${locator}
        Append To List  ${locators}  ${locator_details}
    END
    [Return]  ${locators}