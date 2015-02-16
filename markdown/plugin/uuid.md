#UUID Plugin

This plugin was designed by the ExtJS Team to create a method of identification for each user.  The UUID is generated the first time the plugin is loaded and then stored.

##Links
* [Coffeescript](http://code.ext-js.org/plugins/uuid/uuid.coffee)
* [Unminified](http://code.ext-js.org/plugins/uuid/uuid.js)
* [Minified](http://code.ext-js.org/plugins/uuid/uuid.min.js)

##Usage
Because of the simplicity of this plugin all you have to do is load it. Accessing the UUID is as simple as calling a function.

```javascript
//This will get the UUID
//and return the value.
ext.uuid.get()

//This will reset the UUID
//and return the new value.
ext.uuid.reset()

//This is an alias that can
//be used in the place of uuid.
ext.UUID.get()
```

##Change log
| Date       | Version  | Description     |
|------------|----------|-----------------|
| xx-xx-2015 |  0.1.0   | Release         |

##Licence
MIT Open source
