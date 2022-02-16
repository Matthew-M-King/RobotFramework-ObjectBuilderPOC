*** Settings ***
Library  Collections

*** Keywords ***
Register Table Keyword
    # ...    Registers provided keyword to be invoked for every row of a table that follows.
    # ...    This is in fact the only keyword to be called by the keyword preceding a table:
    # ... 
    # ...      When I add the following numbers
    # ...            ^    num1    num2
    # ...            >    -2      3
    # ...            >    10      15
    # ...            >    -1      -10
    # ...
    # ...    In this case "following calculations are performed" should register a keyword that will make use of the table.
    # ...    You may also choose to ignore table headers and/or to use the table's row number as the
    # ...    first keyword's argument by setting the respective flag.
    # ...    Use args_map to map headers to keyword's argument names, if necessary.
    # ...    ${table_number} is used for constructing a variable storing the values of each row of the table.
    # ...    By default it is set to 1. If more than one table is used in a scenario, and we want to store its values
    # ...    then this variable needs to be incremented in the acceptance keyword using it.
    # ...    ${named_argument_values} can specify values for specific arguments that will be used for all table rows.
    # ...    Works only when header ^ keyword is used. Parameter that is specified this way cannot be defined again in the table itself.
    [Arguments]    ${keyword}    ${ignore_headers}=${FALSE}    ${table_number}=1    ${use_row_number}=${FALSE}
    ...    ${named_argument_values}=&{EMPTY}    &{args_map}
    Set Test Variable    ${table_keyword}    ${keyword}
    Set Test Variable    ${table_arguments_names}    ${EMPTY}
    Set Test Variable    ${table_row_number}    1
    Set Test Variable    ${table_ignore_headers}    ${ignore_headers}
    Set Test Variable    ${table_use_row_number}    ${use_row_number}
    Set Test Variable    &{table_args_map}    &{args_map}
    Set Test Variable    &{table_named_argument_values}    &{named_argument_values}
    Set Test Variable    ${table_number}

^
    [Documentation]    Optional headers for the table. Registers names of values provided in rows.
    ...    Can be ignored by setting ignore_headers=${TRUE} during table keyword registration.
    ...    Table column names must EXACTLY match the names of arguments of the registered keyword in any order.
    ...    See the 'Register Table Keyword' for an example of table's usage.
    [Arguments]    @{headers}
    Return From Keyword If    ${table_ignore_headers}==${TRUE}
    Run Keyword And Return If    ${table_args_map} == {} or ${table_args_map} == { }
    ...    Set Test Variable    ${table_arguments_names}    ${headers}
    @{args_list}    Create List
    @{map_keys}    Get Dictionary Keys    ${table_args_map}
    FOR    ${header}    IN    @{headers}
        ${arg_name}    Set Variable If    "${header}" in @{map_keys}    ${table_args_map}[${header}]    ${header}
        Append To List    ${args_list}    ${arg_name}
    END
    Set Test Variable    ${table_arguments_names}    ${args_list}

>
    [Documentation]    Executes the registered keyword, passing values that follow as its arguments.
    ...    Uses named arguments, if table header was provided before - otherwise uses positional arguments.
    ...    See the 'Register Table Keyword' for an example of table's usage.
    ...    Sets the ${seeded_table_${table_number}_row${table_row_number}_values} variable with arguments passed
    ...    to this keyword, for further assertions e.g. @{seeded_table_1_row_1_values} will store all arguments
    ...    from the first row of the table marked as 1st in the scenario.
    [Arguments]    @{arguments_values}    &{kwargs}
    ${arguments_names}    Get Variable Value    ${table_arguments_names}    ${EMPTY}
    ${row_number}    Set Variable If    ${table_use_row_number}==${TRUE}    ${table_row_number}    ${EMPTY}
    Run Keyword If    "${arguments_names}" == "${EMPTY}"
    ...    Run Table Keyword With Plain Arguments    ${row_number}    @{arguments_values}    &{kwargs}
    ...    ELSE    Run Table Keyword With Named Arguments    ${row_number}    ${arguments_names}    ${arguments_values}
    Set Test Variable    ${seeded_table_${table_number}_row${table_row_number}_values}    ${arguments_values}
    ${table_row_number}    Evaluate    ${table_row_number} + 1
    Set Test Variable    ${table_row_number}

Run Table Keyword With Named Arguments
    [Documentation]    Helper for the '>' keyword, pairing arguments with names to call the registered keyword with them.
    [Arguments]    ${row_number}    ${arguments_names}    ${arguments_values}
    &{arg_value_pairs} =    Create Dictionary
    FOR    ${arg}    ${value}    IN ZIP    ${arguments_names}    ${arguments_values}
        Set To Dictionary    ${arg_value_pairs}    ${arg}    ${value}
    END
    FOR    ${key}    IN    @{table_named_argument_values}
        # Registered values cannot be used together with values from the table - enforce this to avoid potentially difficult to diagnose errors
        List Should Not Contain Value    ${arguments_names}    ${key}
        ...    Table keyword has registered a value for '${key}' argument, but that argument is also listed in the table - this is not supported, only one way of providing a value can be used.
        Set To Dictionary    ${arg_value_pairs}    ${key}    ${table_named_argument_values}[${key}]
    END
    Log Dictionary    ${arg_value_pairs}
    Run Keyword And Return If    "${row_number}" == "${EMPTY}"    ${table_keyword}    &{arg_value_pairs}
    Run Keyword And Return    ${table_keyword}    ${row_number}    &{arg_value_pairs}

Run Table Keyword With Plain Arguments
    [Documentation]    Helper for the '>' keyword, running table keyword with or without row number.
    [Arguments]    ${row_number}    @{arguments_values}    &{kwargs}
    Log Dictionary    ${kwargs}
    Run Keyword And Return If    "${row_number}" == "${EMPTY}"    ${table_keyword}    @{arguments_values}    &{kwargs}
    Run Keyword And Return    ${table_keyword}    ${row_number}    @{arguments_values}    &{kwargs}