- [Robot Framework Object Builder POC](#robot-framework-object-builder-poc)
  - [Core Registry Structure](#core-registry-structure)
  - [Register an App](#register-an-app)
  - [Register Urls](#register-urls)
  - [Register Users If Applicable](#register-users-if-applicable)
  - [Register Pages](#register-pages)



# Robot Framework Object Builder POC

This project demonstrates a Page Object builder approach
enabling easy ability to add new page element locators and maintain existing locators. It's also possible to add element definitions which provides the paramters for asserting given elements within the app under test. It's easy to add new sites, pages and page objects

## Core Registry Structure

```
└───Resources
│   └───Settings
│   │   │   AppRegistry.py
│   │   │   UrlRegistry.yaml
│   │   │   UserRegistry.yaml
│   │
│   └───PO
│       └───DefinitionRegistry
│       │   └───ChallengingDom
│       │   │   │   MainPage.yaml 
│       │   │   
│       │   └───SwagLabs
│       │       │   LoginPage.yaml
│       │       │   ProductsPage.yaml
│       │   
│       └───ObjectRegistry
│       │   └───ChallengingDom
│       │   │   │   MainPage.yaml 
│       │   │   
│       │   └───SwagLabs
│       │       │   LoginPage.yaml
│       │       │   ProductsPage.yaml
│       │
│       └───PageRegistry
│       │   │   _ChallengingDomVariables.robot
│       │   │   _SwagLabsVariables.robot

```


## Register an App

`\\Settings\AppRegistry.py`

| Variable | Description |
| ----------- | ----------- |
| app3 | Dictionary containing the setting variables for core app values |
| default_page | The landing page of the app, name can be personal preference but will be referenced in further stages |
| dynamic_url_contains | Partial text of a dynamic url, None if App doesn't have dynamic pages |
| dynamic_page_name | Name reference for dynamic page, personal preference but will be referenced in further stages |

In the below example, "ExampleApp" in get_variables() is the ${target_app} this variable can be set at command line e.g. robot -d reports -v target_app:ExampleApp -t "My Test Case" .

```
app3 = {
    'default_page': 'MainPage',
    'dynamic_url_contains': None,
    'dynamic_page_name': None
    }

def get_variables(arg):
    if arg == 'SwagLabs':
        return app1
    elif arg == 'ChallengingDom':
        return app2
    elif arg == 'ExampleApp':
        return app3
```

## Register Urls
`\\Settings\UrlRegistry.yaml.py`

| Property | Description |
| ----------- | ----------- |
| SiteUrls | Takes a set of target app names as key and main url as values |
| UrlsToPages | Maps page urls to a page name, page names can be personal preference but will be referenced in further stages. |

Each url key/value should be entered under target app name as below:

```
SiteUrls:
  ChallengingDom: http://the-internet.herokuapp.com/challenging_dom
  SwagLabs: https://www.saucedemo.com/
  ExampleApp: https://www.example_app.com/
UrlsToPages:
  SwagLabs:
    https://www.saucedemo.com/: LoginPage
    https://www.saucedemo.com/inventory.html: ProductsPage
  ChallengingDom: 
    http://the-internet.herokuapp.com/challenging_dom: MainPage
  ExampleApp:
    https://www.example_app.com/example_page: ExamplePage
    https://www.example_app.com/hello_world.html: AnotherExamplePage
```

## Register Users If Applicable
`\\Settings\UserRegistry.yaml`

For registering new users - first add the target app under "UserLogins" e.g. "ExampleApp:" Now under the target app, add a login type such as "Default", "Locked", "Invalid" etc. The user names and passwords will go under the user types as per the example below.

```
UserLogins:
  SwagLabs:
    Default:
      UserName: standard_user
      Password: secret_sauce
    Locked: 
      UserName: locked_out_user
      Password: secret_sauce
    Problem:
      UserName: problem_user
      Password: secret_sauce
    Glitched:
      UserName: performance_glitch_user
      Password: secret_sauce 
  ExampleApp:
    Default:
      UserName: example_user
      Password: example_password 

```

## Register Pages
`\\PO\PageRegistry\_ExampleAppVariables.robot`

Add a file e.g. \_ExampleAppVariables.robot to the PageRegistry - This will contain references to yaml files (Page Object and Definition files).
Note the name of the file is important, it should be prefixed with underscore followed by the target app name and suffixed with "Variables" e.g. "_${target_app}Variables.robot"
