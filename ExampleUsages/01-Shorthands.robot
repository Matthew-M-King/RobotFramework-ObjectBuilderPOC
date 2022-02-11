*** Settings ***
Library  String

Resource  ../Keywords/01-ShorthandKeywords.robot

*** Variables ***
${variable_set_as_none}     ${NONE}
${variable_set_as_empty}    ${EMPTY}
${variable_set_as_value}    Hello World
@{list_of_numbers}          1  2  3  4  5
@{nest_set_1}               1  2  3
@{nest_set_2}               4  5  6
@{nest_set_3}               7  8  9
@{nested_list}              ${nest_set_1}   ${nest_set_2}   ${nest_set_3}
 
*** Test Cases ***
Coalescing Operator
    ${variable_set_as_none}    ??  ${variable_set_as_none}    <-  Hello
    ${variable_set_as_empty}   ??  ${variable_set_as_empty}   <-  World 
    ${variable_set_as_value}   ??  ${variable_set_as_value}   <-  Hi

    Log To Console  \nVariable was None is now: ${variable_set_as_none}
    Log To Console  Variable was Empty is now: ${variable_set_as_empty}
    Log To Console  Variable was Hello World should not change, is now: ${variable_set_as_value}

    Should be Equal As Strings  ${variable_set_as_none}   Hello
    Should be Equal As Strings  ${variable_set_as_empty}  World
    Should be Equal As Strings  ${variable_set_as_value}  Hello World

Iterations On One Line 
    ->FOR  ${list_of_numbers}  ->message  Log To Console

Shortened Set Variable
    ${example_var}  <-  Hello World!
    Log To Console  \n${example_var}

Flatten a List
    log to console  \nBefore: ${nested_list}
    ${flat_list}  [_]  ${nested_list}
    log to console  After: ${flat_list}

