*** Settings ***
Resource  ../PO/_Keywords/List.robot
Resource  ../PO/_Keywords/Page.robot
Resource  ../PO/_Keywords/Table.robot

*** Keywords ***
### GIVEN ###
the "${page}" page is displayed
    PO: Page: Navigate To  ${page}

the "${page}" page is displayed for ${user_type} User
    PO: Page: Navigate To  ${page}  ${user_type}
    
### WHEN ###
${r:(.*)?} views elements of the current page
    ${current_page}  PO: Page: Get
    ${locators}  Build Locators
    Set Test Variable  ${${current_page}_current_page_locators}  ${locators}
    
${r:(.*)?} selects ${position:(\d+|last)}${r:(st|nd|rd|th)?} "${target_list}" list option
    PO: List: Select Option At Position  ${target_list}  ${position}

### THEN ###
the current page should contain correct elements
    PO: Common: Assert Current Page Elements
    
elements on current page should contain correct values
    PO: Common: Locators Should Contain Values

the "${table}" table should contain correct content
    PO: Table: Assert Table Content  ${table}