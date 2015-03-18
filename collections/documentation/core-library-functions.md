#Core Library Functions

_This is a list of functions found in the ExtJS library._
### The breakdown
* [Initialize](documentation/core-library-functions#initialize)
* [Options](documentation/core-library-functions#options)
* [Match](documentation/core-library-functions#match)
* [Menu](documentation/core-library-functions#menu)


### Initialize
This is the initialize function that must be called in order to use the library.
* **Function** - `ext.ini(options)`

Initialize Options Defaults
```json
{
  "verbose" : false
}
```
Initialize Options Breakdown

* **verbose** - `boolean` (do not log warning and other debug info to the Javascript console)


### Options
This is a set of functions for getting, setting, and resetting extension options.
* **Get** - `ext.options.get(key)`
* **Set** - `ext.options.set(key, value)`
* **Reset** - `ext.options.set(key)`
* **resetAll** - `ext.options.resetAll(exceptions)`


### Match
This currently only contains one function, but is one of the most powerful functions in this framework. This function is used for searching URLs using the frameworks "URL Search Syntax". While this is not, directly useful other functions can tap into this making it very powerful.
* **URL** - `ext.match.url(url, urlSearchSyntax)`


### Menu
This set of functions allows you to manipulate the extension's toolbar item by setting the icon, resetting the icon, setting the badge, getting the badge, and adding a callback when clicked.
* **click** - `ext.menu.click(callback)`
* **setIcon** - `ext.menu.setIcon(url)`
* **resetIcon** - `ext.menu.getIcon()`
* **setBadge** - `ext.menu.setBadge(Int)`
* **getBadge** - `ext.menu.getBadge(callback)`
