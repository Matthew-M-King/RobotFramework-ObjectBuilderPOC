*** Settings ***
Variables  UrlRegistry.yaml
Variables  UserRegistry.yaml
Variables  AppRegistry.py  ${target_app}

*** Variables ***
${browser}               Chrome
${target_app}            SwagLabs
${headless}              ${FALSE}
${current_login_user}