""" This file contains settings desired for the app under test.
Where ${target_app} specifies the desired system details as returned by the get_variables() special function.
See the following URL for details:
http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#getting-variables-from-a-special-function
"""

app1 = {
    'default_page': 'LoginPage',
    'dynamic_url_contains': 'inventory-item',
    'dynamic_page_name': 'ProductPage',
    'environment': 'Web'
    }

app2 = {
    'default_page': 'MainPage',
    'dynamic_url_contains': None,
    'dynamic_page_name': None,
    'environment': 'Web'
    }



def get_variables(arg):
    if arg == 'SwagLabs':
        return app1
    elif arg == 'ChallengingDom':
        return app2