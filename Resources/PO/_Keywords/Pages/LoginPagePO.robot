*** Settings ***
Resource    ../Input.robot


*** Keywords ***
Login App
    [Arguments]    ${user_type}
    ${username}    <-    ${UserLogins.${user_type}.UserName}
    ${password}    <-    ${UserLogins.${user_type}.Password}
    PO: Input: Await And Input Text    Username    ${username}
    PO: Input: Await And Input Text    Password    ${password}
    PO: Input: Await And Click Button    LoginButton
