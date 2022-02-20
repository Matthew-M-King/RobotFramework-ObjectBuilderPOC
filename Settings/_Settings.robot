*** Settings ***
Variables  AppRegistry.py  ${target_app}
Resource   DataSets/${target_app}/${environment}/_DatasetRegistry.robot


*** Variables ***
${browser}               Chrome
${target_app}            SwagLabs
${headless}              ${FALSE}
${environment}           Staging
${current_login_user}