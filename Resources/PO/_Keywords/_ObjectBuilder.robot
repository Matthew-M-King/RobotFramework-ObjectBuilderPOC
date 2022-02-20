*** Settings ***
Resource   ../PageRegistry/_${target_app}Variables.robot
Library    Collections

*** Keywords ***
Build Locator
    [Documentation]  Build locator based on locator definition yaml files and supported locator strategies:
    ...   ParentReferenceWithXpathLookup
    ...   ParentReferenceWithType
    ...   ParentReferenceWithAttribute
    ...   ParentReferenceWithRelationshipAxes
    ...   ParentReferenceWithText
    ...   XPathLookup
    ...   WithAttribute
    ...   WithText
    ...   SelectFromGroupByCSSProperty
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
    ${locator}  Run Keyword  Build Locator: ${locator_strategy}   ${properties}  ${page}  ${extension}
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
    ${axes}  Build Locator: Add Relationship Axes  ${properties}  ${page}  ${extension}
    Run Keyword And Return  <-  ${axes}${properties.Xpath}

Build Locator: WithType
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${type}        <-   ${properties.ElementType}
    ${axes}  Build Locator: Add Relationship Axes  ${properties}  ${page}  ${extension}=${EMPTY}
    Run Keyword And Return  <-  ${axes}//${type}

Build Locator: WithAttribute
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${attribute}   <-   ${properties.Attribute}
    ${name}        <-   ${properties.Name}
    ${type}        <-   ${properties.ElementType}
    ${axes}  Build Locator: Add Relationship Axes  ${properties}  ${page}  ${extension}=${EMPTY}
    Run Keyword And Return  <-  ${axes}//${type}\[@${attribute}="${name}"]${extension}

Build Locator: WithText
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${text}  <-  ${properties.Text}
    ${type}  <-  ${properties.ElementType}
    ${axes}  Build Locator: Add Relationship Axes  ${properties}  ${page}  ${extension}=${EMPTY}
    Run Keyword And Return  <-  ${axes}//${type}\[normalize-space()="${text}"]${extension}

Build Locator: WithContainsAttribute
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${attribute}            <-   ${properties.Attribute}
    ${name}                 <-   ${properties.Name}
    ${axes}  Build Locator: Add Relationship Axes  ${properties}  ${page}  ${extension}=${EMPTY}
    Run Keyword And Return  <-  ${axes}//${properties.ElementType}\[contains(@${attribute}, "${name}")]${extension}

Build Locator: SelectFromGroupByCSSProperty
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${group_reference}     <-   ${properties.GroupReference}
    ${css_property_type}   <-   ${properties.CSSPropertyType}
    ${group_locator}  Build Locator  ${group_reference}
    ${group}  Get WebElements  ${group_locator}
    FOR  ${element}  IN  @{group}
        ${element_property}  Call Method  ${element}  value_of_css_property  ${css_property_type}
        Return From Keyword If  "${element_property}"=="${properties.PropertyValue}"  ${element}
    END

Build Locator: Add Relationship Axes
    [Arguments]  ${properties}  ${page}  ${extension}=${EMPTY}
    ${is_relation}   Is Key?  ${properties}  UseRelation
    Return From Keyword If  not ${is_relation}   ${EMPTY}
    Return From Keyword If  not ${properties.UseRelation}  ${EMPTY}
    ${relation}  <-   ${properties.Relation}
    ${type}  <-  ${properties.RelationElementType}
    Run Keyword And Return  <-  //${relation}::${type}
    
### INTERNAL ###
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

Build Locator: Get Parent Target Element
    [Arguments]  ${target_element}
    ${page}  PO: Page: Get
    ${dicts}  <-  ${${page}_Objects}
    Run Keyword And Return  <-  ${dicts.${target_element}.ParentReference}

Build Locator: Update Parent With Index
    [Arguments]  ${target_element}  ${index}
    ${target_parent_element}  Build Locator: Get Parent Target Element  ${target_element}
    ${parent_locator}  Build Locator  ${target_parent_element}
    ${locator}         Build Locator  ${target_element}
    ${locator}         Replace String  ${locator}  ${parent_locator}  ${EMPTY}
    
    ${parent_locator}  <-   ${parent_locator}\[${index}]
    Run Keyword And Return  <-   ${parent_locator}${locator}

