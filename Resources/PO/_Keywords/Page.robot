*** Settings ***
Resource   Common.robot

*** Keywords ***
PO: Page: Get
    ${url}    Get Location
    ${is_dynamic_page}  Run Keyword And Return Status  Should Contain  ${url}  ${dynamic_url_contains}
    # Handle special case of dynamic pages
    IF  not ${is_dynamic_page} 
        Return From Keyword  ${UrlsToPages.${target_app}}[${url}]
    ELSE 
        Return From Keyword  ${dynamic_page_name}
    END

PO: Page: Navigate To
    [Arguments]  ${page}  ${user}=Default
    ${actual_page}  PO: Page: Get
    ${is_page}  PO: Page: IsPage?  ${page}  ${actual_page}
    
    # Check if the current test is using same user as previous tests so we can stay logged in
    IF  "${current_login_user}"
        IF  "${current_login_user}"=="${user}"
            Return From Keyword If  ${is_page}
        ELSE
            IF  "${actual_page}"!="${default_page}"
                ${page_url}   PO: Page: Get Page Url From Registry  ${default_page} 
                Go To  ${page_url}
                ${actual_page}  PO: Page: Get
            END
        END
    END

    IF  "${actual_page}"=="${default_page}"
        Login App  ${user}
        Set Suite Variable  ${current_login_user}  ${user}
        ${actual_page}  PO: Page: Get
        Return From Keyword If  ${is_page}
        ${page_url}   PO: Page: Get Page Url From Registry  ${page}
        Go To  ${page_url}
    END

PO: Page: IsPage?
    [Arguments]  ${expected}  ${actual}
    Run Keyword And Return  Run Keyword And Return Status  Should Be Equal As Strings  ${expected}  ${actual}

PO: Page: Get Page Url From Registry 
    [Arguments]  ${page}
    FOR  ${page_url}  IN  @{UrlsToPages.${target_app}}
        ${page_name}  <-  ${UrlsToPages.${target_app}}[${page_url}]
        IF  "${page}"=="${page_name}" 
            Run Keyword And Return  <-  ${page_url}
        END
    END