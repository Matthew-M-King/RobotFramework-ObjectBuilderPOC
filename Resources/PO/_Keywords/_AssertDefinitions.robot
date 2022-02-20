*** Settings ***
Resource   ../PageRegistry/_${target_app}Variables.robot
Library    Collections

*** Keywords ***
PO: Assert Definitions
    ${page}  PO: Page: Get
    ${dicts}  <-  ${${page}_Definitions}
    FOR  ${target_element}  IN  @{dicts.keys()}
        FOR  ${property}  IN  @{dicts.${target_element}.keys()}
            Run Keyword   PO: Assert Definitions: ${property}   ${target_element}  ${dicts}
        END
    END

PO: Assert Definitions: ShouldContain
    [Arguments]  ${target_element}  ${definitions}
    ${expected_text}  <-  ${definitions.${target_element}.ShouldContain}
    PO: Common: Locator Should Contain Value  ${target_element}  ${expected_text}

PO: Assert Definitions: EachInGroupShouldContain
    [Arguments]  ${target_element}  ${definitions}
    Fail  Not Implemented

PO: Assert Definitions: ElementCountShouldBe
    [Arguments]  ${target_element}  ${definitions}
    FOR  ${target_element}  IN  @{definitions.keys()}
        ${locator}  Build Locator  ${target_element}
        ${count}  <-  ${definitions}[${target_element}][ElementCountShouldBe]
        Page Should Contain Element  ${locator}  limit=${count}
    END

PO: Assert Definitions: TableContentShouldBe
    [Arguments]  ${target_element}  ${definitions}
    ${target_element_def}  <-  ${definitions}[${target_element}]
    ${target_content_def}  <-  ${target_element_def}[TableContentShouldBe]
    ${table_content}       <-  ${target_content_def}[Columns]
    ${result}   PO: Table: Assert Table Content  ${target_element}   ${table_content}
    IF    not ${result}
        Fail    Table content or table definition was incorrect
    END