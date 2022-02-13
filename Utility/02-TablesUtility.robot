*** Settings ***
Resource  ../Keywords/02-TableKeywords.robot

*** Keywords ***
### BINDINGS ###

I have a calculator
    No Operation

I add the following numbers
    Register Table Keyword  Add Numbers

the totals of calculations should be:
    Register Table Keyword  Assert Totals


### INTERNAL ###
Add Numbers
    [Documentation]  Internal helper keyword that adds two numbers for table example
    [Arguments]  ${num1}  ${num2}
    ${is_total_list}  Run Keyword And Return Status  Variable Should Exist  ${current_total_list}
    IF  not ${is_total_list}
        @{current_total_list}  Create List
        Set Test Variable   ${current_total_list}
    END
    ${total}  Evaluate  ${num1}+${num2}
    Append To List  ${current_total_list}  ${total}

Assert Totals
    [Arguments]  ${expected_total}
    ${index}  Evaluate   ${table_row_number}-1
    Should Be Equal As Strings  ${current_total_list}[${index}]  ${expected_total}