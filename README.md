# Robot Framework Object Builder POC

This project demonstrates a Page Object builder approach
enabling easy ability to add new page element locators and maintain existing locators

It's also possible to add element definitions which provides the paramters for assering given elements within the app under test

It's easy to add new sites, pages and page objects

## Register an App in the AppRegistry.py file

    - default_page = The landing page of the app, name can be personal preference but will be referenced in further stages
    - dynamic_url_contains = Partial text of a dynamic url, None if App doesn't have dynamic pages
    - dynamic_page_name = Name reference for dynamic page, personal preference but will be referenced in further stages
    - In the below example, "ExampleApp" in get_variables() is the ${target_app} this variable can be set at command line e.g. robot -d reports -v target_app:ChallengingDom -t "My Test Case" .

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

    - SiteUrls = Takes target app name as key and main url as value
    - UrlsToPages = Maps page urls to a page name, page names can be personal preference but will be referenced in further stages. each url key/value should be entered under target app name as below:

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
```
