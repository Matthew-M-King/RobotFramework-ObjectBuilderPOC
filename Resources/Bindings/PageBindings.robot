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

${r:(.*)?} clicks the "${button}" button
    PO: Input: Await And Click Button  ${button}

${r:(.*)?} clicks the "${link}" link
    PO: Input: Await And Click Link  ${link}

### THEN ###
the current page should contain correct elements
    PO: Common: Assert Current Page Elements
    
elements on current page should contain correct values
    PO: Common: Locators Should Contain Values

the "${table}" table should contain correct content
    PO: Table: Assert Table Content  ${table}

the following option should be selected in list:
    Register Table Keyword  PO: List: Assert Active Option  Option=value  List=target_element

the "${target_elements}" should be sorted high to low ${value_type}
    PO: Common: Assert Element Group Sort Order  ${target_elements}  HighToLow${value_type}

the "${target_elements}" should be sorted low to high ${value_type}
    PO: Common: Assert Element Group Sort Order  ${target_elements}  LowToHigh${value_type}

the "${target_element}" should display text: ${text}
    PO: Common: Await And Assert Element Text  ${target_element}  ${text}

the page should display following number of "${target_element}": ${amount}
    PO: Common: Await And Assert X Number Of Elements  ${target_element}  ${amount}