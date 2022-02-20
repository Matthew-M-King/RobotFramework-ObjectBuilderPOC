*** Settings ***
Resource   Common.robot

*** Keywords ***
PO: Page: Get
    ${url}    Get Location
    ${is_dynamic_page}  Run Keyword And Return Status  Should Contain  ${url}  ${dynamic_url_contains}
    # Handle special case of dynamic pages
    IF  not ${is_dynamic_page} 
        FOR  ${page_name}  IN  @{UrlsToPages}
            IF  "${UrlsToPages}[${page_name}]"=="${url}"
                Return From Keyword  ${page_name}
            END
        END
    ELSE 
        Return From Keyword  ${dynamic_page_name}
    END

PO: Page: Navigate To
    [Arguments]  ${page}  ${user}=Default  ${perform_login}=${TRUE}
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

    IF  "${actual_page}"=="${default_page}" and "${page}"!="${default_page}"
        
        IF  ${perform_login}
            Login App  ${user}
            Set Suite Variable  ${current_login_user}  ${user}
            ${actual_page}  PO: Page: Get
            Return From Keyword If  ${is_page}
        END
        ${page_url}   PO: Page: Get Page Url From Registry  ${page}
        Go To  ${page_url}
    END

PO: Page: IsPage?
    [Arguments]  ${expected}  ${actual}
    Run Keyword And Return  Run Keyword And Return Status  Should Be Equal As Strings  ${expected}  ${actual}

PO: Page: Get Page Url From Registry
    [Arguments]  ${page}
    Run Keyword And Return  <-  ${UrlsToPages}[${page}]