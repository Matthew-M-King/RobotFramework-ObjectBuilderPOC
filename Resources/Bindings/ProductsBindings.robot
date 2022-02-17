*** Settings ***
Resource  ../PO/_Keywords/List.robot
Resource  ../PO/_Keywords/Page.robot
Resource  ../PO/_Keywords/Table.robot

*** Keywords ***
user adds following number of products to basket:
    [Arguments]  ${amount}
    PO: Input: Await And Click X Number Of Buttons   InventoryAddToCart  ${amount}