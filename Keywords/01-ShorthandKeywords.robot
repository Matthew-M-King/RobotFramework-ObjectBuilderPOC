*** Keywords ***
??
    [Documentation]    Coalescing operator for {NONE} or {EMPTY} values.
    ...    Similar to what can be used in other programming languages.
    ...    Example:
    ...    ${example_id}    ??    ${example_id}    Get Default Example Id
    [Arguments]    ${variable}    ${keyword}    @{args}    &{kwargs}
    Return From Keyword If    "${variable}"!="${EMPTY}" and "${variable}"!="${NONE}"    ${variable}
    Run Keyword And Return    ${keyword}    @{args}    &{kwargs}

?>
    [Documentation]    Short-hand syntax for:    Run Keyword If    "${variable}"!="${EMPTY}"
    ...    Does not work, if the keyword to be called is actually 'Run Keywords'.
    [Arguments]    ${variable}    ${keyword}    @{args}    &{kwargs}
    Return From Keyword If    "${variable}"=="${EMPTY}"
    Run Keyword And Return    ${keyword}    @{args}    &{kwargs}

<- 
    [Documentation]    Shortened syntax for "Set Variable" - returns the argument.
    [Arguments]    ${value}
    [Return]    ${value} 

->FOR
    [Documentation]    Provides simple facility to execute the same keyword for each item on a list.
    ...    The arg_mapping must be constructed like '->keyword_argument_name'.
    ...    Example:
    ...    ->FOR  ${list_of_numbers}  ->message  Log To Console
    ...
    ...    This will call the "Log To Console" keyword, with each element of a list
    ...    obtained by the list_of_numbers call passed to this keyword as the message argument.
    ...    Note that the list is provided with $ and not @ to avoid arguments ambiguity.
    ...    all the remaining arguments of a keyword can be passed to it as usual.
    [Arguments]    ${list}    ${arg_mapping}    ${keyword}    @{remaining_args}    &{remaining_kwargs}
    Should Start With    ${arg_mapping}    ->
    ${arg_name}=    Get Substring    ${arg_mapping}    2
    FOR    ${item}    IN    @{list}
        Run Keyword    ${keyword}    @{remaining_args}    &{remaining_kwargs}    ${arg_name}=${item}
    END

[_]
    [Arguments]  ${list}
    Run Keyword And Return    Evaluate    [item for sublist in $list for item in (sublist if isinstance(sublist, list) else [sublist])]