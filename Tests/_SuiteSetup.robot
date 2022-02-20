*** Settings ***
Documentation  Setup Tests

Library   SeleniumLibrary
Resource  ../Settings/_Settings.robot
Resource  ../Resources/Utility/ShorthandUtility.robot
Resource  ../Resources/Utility/TablesUtility.robot
Resource  ../Resources/PO/_Keywords/Pages/LoginPagePO.robot

*** Keywords ***
Begin Suite
    ${options}  Configure Browser
    Open Browser  ${BaseUrl}  ${browser}  options=${options}
    Maximize Browser Window

Begin Suite With ${user_type} User
    Begin Suite
    Login App  ${user_type}

Begin Web Test
    Delete All Cookies
    Delete Storage
    Reload Page
    
Teardown Suite
    Close All Browsers

Configure Browser
    [Arguments]  ${language}=en
    ${prefs}=   Create Dictionary
    ...  profile.default_content_setting_values.automatic_downloads=1
    ...  download.prompt_for_download=false
    ${options}=  Run Keyword If  '${browser}'=='Chrome'  Evaluate  sys.modules['selenium.webdriver'].ChromeOptions()  sys, selenium.webdriver
    ...  ELSE  Evaluate  sys.modules['selenium.webdriver'].EdgeOptions()  sys, selenium.webdriver
    ${options.use_chromium}=  Set Variable If  '${browser}'=='Edge'  True
    Call Method  ${options}  add_argument  --lang\=${language}
    Call Method  ${options}  add_argument  --disable-infobars
    Call Method  ${options}  add_argument  --allow-insecure-localhost
    Call Method  ${options}  add_experimental_option  prefs   ${prefs}
    IF  ${headless}
        Call Method  ${options}  add_argument  --headless
        Call Method  ${options}  add_argument  --disable-gpu
        Call Method  ${options}  add_argument  --disable-extensions
        Call Method  ${options}  add_argument  --disable-sync
        Call Method  ${options}  add_argument  --no-default-browser-check
        Call Method  ${options}  add_argument  --no-first-run
        Call Method  ${options}  add_argument  --window-size\=1920,970
        Call Method  ${options}  add_argument  --log-level\=1
    END
    [Return]  ${options}

Delete Storage
    [Documentation]    Deletes browser's localStorage and sessionStorage.
    ...    You should reload page or go to another URL after executing this keyword.
    Execute JavaScript
    ...    if (window !== null) {
    ...    if (window.sessionStorage !== null) { window.sessionStorage.clear(); }
    ...    if (window.localStorage !== null) { window.localStorage.clear(); }
    ...    }