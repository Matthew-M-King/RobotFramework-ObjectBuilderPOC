*** Settings ***
Resource   Common.robot

*** Variables ***
${locator_table_cell}  //tbody/tr[{0}]//td[{1}]

*** Keywords ***
PO: Table: Assert Table Content
    [Arguments]  ${target_element}
    ${current_page}  PO: Page: Get
    
    ${is_key}  Is Key?  ${${current_page}_Definitions}  ${target_element}
    IF  not ${is_key} 
        Fail  No definition registered for "${target_element}"
    END

    ${is_table_content}  Is Key?  ${${current_page}_Definitions.${target_element}}  TableContent
    IF  not ${is_table_content} 
        Fail  No TableContent found in definition registered for "${target_element}"
    END

    ${table_locator}  Build Locator  ${target_element}
    ${table_header}   <-  ${table_locator}//th

    ${expected_table_content}  <-  ${${current_page}_Definitions.${target_element}.TableContent.Columns}
    
    FOR  ${col}  IN  @{expected_table_content}
        ${rows}       <-  ${expected_table_content.${col}.Rows}
        ${col_index}  <-  ${expected_table_content.${col}.ColumnNo}
        ${row_index}  <-  ${1}
        
        FOR  ${expected_table_cell_value}  IN  @{rows}
            ${current_cell}  Format String  ${locator_table_cell}  ${row_index}  ${col_index}
            ${current_table_cell}  <-  ${table_locator}${current_cell}
            ${actual_table_cell_value}  Get Text  ${current_table_cell}
            Should Be Equal As Strings   ${expected_table_cell_value}  ${actual_table_cell_value}
            ${row_index}  Evaluate  ${row_index}+1
        END

    END
    