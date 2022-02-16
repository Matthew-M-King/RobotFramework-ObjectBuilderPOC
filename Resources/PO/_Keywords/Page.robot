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
    Return From Keyword If  ${is_page}
    IF  "${actual_page}"=="${default_page}"
        Login App  ${user}
        ${actual_page}  PO: Page: Get
        Return From Keyword If  ${is_page}
        FOR  ${page_url}  IN  @{UrlsToPages.${target_app}}
            IF  "${page_url}"=="${page}"
                Go To  ${page_url}
            END
        END
    END

PO: Page: IsPage?
    [Arguments]  ${expected}  ${actual}
    Run Keyword And Return  Run Keyword And Return Status  Should Be Equal As Strings  ${expected}  ${actual}