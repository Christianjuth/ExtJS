#Tabs Plugin

This plugin is used for creating, getting, and searching browser tabs.

##Links
* [Coffeescript](http://code.ext-js.org/plugins/tabs/tabs.coffee)
* [Unminified](http://code.ext-js.org/plugins/tabs/tabs.js)
* [Minified](http://code.ext-js.org/plugins/tabs/tabs.min.js)

##Usage

```javascript
//This will search the browser
//for a google.com tab.
ext.tabs.indexOf("**google.*", function(tabs){
  console.log(tabs);
});

//This will return and array
//containing all tabs
ext.tabs.dump(function(tabs){
  console.log(tabs);
});

//This function will go
//to an imputed target url
ext.tabs.create("http://google.com")

//If the second parameter is
//true the url will be opened
//in a new tab
ext.tabs.create("http://google.com",true)
```

##Changelog
| Date       | Version  | Description     |
|------------|----------|-----------------|
| xx-xx-2015 |  0.1.0   | Release         |

##Licence
MIT Open source
