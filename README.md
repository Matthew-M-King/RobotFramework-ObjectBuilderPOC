# Robot Framework Object Builder POC

## Table of Contents

- [Robot Framework Object Builder POC](#robot-framework-object-builder-poc)
  - [Table of Contents](#table-of-contents)
  - [Preface](#preface)
  - [Core Registry Structure](#core-registry-structure)
  - [Register an App](#register-an-app)
    - [Variables](#variables)
    - [Example Usage](#example-usage)
  - [Register Urls](#register-urls)
  - [Register Users](#register-users)
  - [Register Pages](#register-pages)
  - [Object Registry](#object-registry)
    - [Folder Structure](#folder-structure)
    - [YAML File Example](#yaml-file-example)
    - [Object Builder Locator Strategies](#object-builder-locator-strategies)
  - [Definition Registry](#definition-registry)
    - [Folder Structure](#folder-structure-1)

## Preface

This project demonstrates a Page Object builder approach
enabling easy ability to add new page element locators and maintain existing locators. It's also possible to add element definitions which provides the paramters for asserting given elements within the app under test. It's easy to add new sites, pages and page objects.

## Core Registry Structure

Below attempts to illustrate the core file structure utilised when registering new apps, pages, objects and definitions

```
└───Settings
│   │  _Settings.robot
│   │  AppRegistry.py
│   │
│   └───DataSets
│   │  │
│   │  └───ChallengingDom
│   │  │   │   
│   │  │   └───Dev
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   MainPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│   │  │   │
│   │  │   └───Staging
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   MainPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│   │  │   │
│   │  │   └───UAT
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   MainPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│   │  │   │
│   │  └───SwagLabs
│   │  │   │
│   │  │   └───Dev
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   LoginPageDefinitions.yaml
│   │  │   │   ProductsPageDefinitions.yaml
│   │  │   │   ShoppingCartPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│   │  │   │
│   │  │   └───Staging
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   LoginPageDefinitions.yaml
│   │  │   │   ProductsPageDefinitions.yaml
│   │  │   │   ShoppingCartPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│   │  │   │
│   │  │   └───UAT
│   │  │   │   _DatasetRegistry.robot
│   │  │   │   LoginPageDefinitions.yaml
│   │  │   │   ProductsPageDefinitions.yaml
│   │  │   │   ShoppingCartPageDefinitions.yaml
│   │  │   │   UrlRegistry.yaml
│   │  │   │   UserRegistry.yaml
│
└───Resources
│   │
│   └───PO   
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

---
## Register an App

`\\Settings\AppRegistry.py`

### Variables

| Variable | Description |
| ----------- | ----------- |
| app3 | Dictionary containing the setting variables for core app values |
| default_page | The landing page of the app, name can be personal preference but will be referenced in further stages |
| dynamic_url_contains | Partial text of a dynamic url, None if App doesn't have dynamic pages |
| dynamic_page_name | Name reference for dynamic page, personal preference but will be referenced in further stages |

---
### Example Usage

In the below example, "ExampleApp" in get_variables() is the ${target_app} this variable can be set at command line e.g. robot -d reports -v target_app:ExampleApp -t "My Test Case" .

```python
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
---
## Register Urls
`\\Settings\DataSets\{target_app}\{environment}\UrlRegistry.yaml`

URL's are registered at the App -> Environment level within a Dataset, because of this, it is important that the ${target_app} and ${environment} variables match with the folder structure.

| Property | Description |
| ----------- | ----------- |
| SiteUrls | Takes a set of target app names as key and main url as values |
| UrlsToPages | Maps page urls to a page name, page names can be personal preference but will be referenced in further stages. |

Each url key/value should be entered under target app name as below:

```yaml
BaseUrl:
  ExampleApp: https://www.example_app.com/
UrlsToPages:
  ExamplePage: https://www.example_app.com/example_page
  AnotherExamplePage: https://www.example_app.com/hello_world.html
```

---

## Register Users
`\\Settings\DataSets\{target_app}\{environment}\UserRegistry.yaml`

For registering new users. Add a login type such as __Default__, __Locked__, __Invalid__ etc. The user names and passwords will go under the user types as per the example below.

```yaml
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
---
## Register Pages
`\\PO\PageRegistry\_ExampleAppVariables.robot`

Add a file e.g. \_ExampleAppVariables.robot to the PageRegistry - This will contain references to yaml files (Page Object and Definition files).
Note the name of the file is important, it should be prefixed with underscore followed by the target app name and suffixed with "Variables" e.g. "_${target_app}Variables.robot"

The contents of the file will reference yaml variable files for element definitions (contains a "blueprint" of the types of values to assert for specified objects) and page objects (yaml file containing locators)

The file content would look similar to this:

```robotframework
*** Settings ***
Variables  ../ObjectRegistry/${target_app}/ExamplePage.yaml
Variables  ../DefinitionRegistry/${target_app}/ExamplePage.yaml
```
---
## Object Registry
The Object Registry is a repository containing yaml files, each yaml file is based on a page of the app and contains the page object element locators defined in various forms.

### Folder Structure

When adding a Object Registry yaml file, the directory structure is important - As seen in Register Pages section, the yaml is referenced within ../ObjectRegistry/${target_app}/ExamplePage.yaml

Therefore continuing with the example we would add a new folder __ExampleApp__ under __ObjectRegistry__ folder

---

### YAML File Example

```yaml
LoginPage_Objects:
  Username:
    LocatorStrategy: XPathLookup
    Xpath: //input[@data-test="username"]
  Password:
    LocatorStrategy: WithAttribute
    ElementType: input
    Attribute: data-test
    Name: password
```

### Object Builder Locator Strategies

| LocatorStrategy | Description |
| ----------- | ----------- |
| ParentReferenceWithXpathLookup | Reference a parent element as prefix - child locator directly added as xpath 
| ParentReferenceWithContainsAttribute | Reference a parent element as prefix - child locator built with contains attribute 
| ParentReferenceWithType | Reference a parent element as prefix - child is simply an element type 
| ParentReferenceWithAttribute | Reference a parent element as prefix - child locator built with attribute 
| ParentReferenceWithText | Reference a parent element as prefix - child locator built with expected text 
| XPathLookup | direct xpath lookup 
| WithAttribute | built with attribute 
| WithText | built with expected text 
| WithContainsAttribute | built with contains attribute 
| SelectFromGroupByCSSProperty | References an element group and RF keyword will run to derive correct element from the group based on CCS properties 

---
## Definition Registry
The definition registry yaml files aim to describe the behaviour and properties/attributes of locators on a page with the intention to guide the automation in asserting page specifics in a simple, maintainable manner. The definition files are stored in datasets allowing plenty of room for scalability and enhancements.

### Folder Structure

When adding a Definition Registry yaml file, the directory structure is important. The definition files are stored in datasets which can differ at an environment level  

`\\Settings\DataSets\{target_app}\{environment}\ExamplePageDefinitions.yaml`

`\\Settings\DataSets\{target_app}\{environment}\AnotherExamplePageDefinitions.yaml`

Each of the environment directories will contain a _Definitions.robot file to import the variables from the yaml's

`\\Settings\DataSets\{target_app}\{environment}\_Definitions.robot`

```robotframework
*** Settings ***
Variables  ExamplePageDefinitions.yaml
Variables  AnotherExamplePageDefinitions.yaml
```


```yaml
LoginPage_Definitions:
  Username:
    ElementCountShouldBe: 1
  Password:
    ElementCountShouldBe: 1
  LoginButton:
    ElementCountShouldBe: 1
  LoginCredentials:
    ElementCountShouldBe: 1
    ShouldContain:
      - standard_user
      - locked_out_user
      - problem_user
      - performance_glitch_user
  AcceptedUsernamesTitle:
    ElementCountShouldBe: 1
    ShouldContain:
      - Accepted usernames are
```

Note that locator attribute should be named the same as the object in the ObjectRegistry

__ObjectRegistry__

```yaml
LoginPage_Objects:
  Username:
    LocatorStrategy: XPathLookup
    Xpath: //input[@data-test="username"]
    Assert: True
```

__DefinitionRegistry__

```yaml
LoginPage_Definitions:
  Username:
    ElementCountShouldBe: 1
```