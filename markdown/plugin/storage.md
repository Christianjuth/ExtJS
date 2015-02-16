#Storage Plugin



##Links
* [Coffeescript](http://code.ext-js.org/plugins/storage/storage.coffee)
* [Unminified](http://code.ext-js.org/plugins/storage/storage.js)
* [Minified](http://code.ext-js.org/plugins/storage/storage.min.js)

##Usage
This is a small set of functions for storing, getting, resetting, and removing items. The items are stored in a single localStorage element. Because the items are stored as a string and parsed as a JSON object on the fly this allows you to store values other then strings. This should be used as an alternative to localStorage and not along with it.

```javascript
//This will set the target
//storage item and return storage
//JSON object.
ext.storage.set("Key","Value")

//This will return the
//target storage item.
ext.storage.get("Key")

//This will remove the target
//storage item from the storage
//object
ext.storage.remove("key")

//This will remove all storage
//items in the storage object
ext.storage.removeAll(["exception1","exception2"])

//This will return an array of all
//storage item keys in the storage
//object
ext.storage.dump()
```

##Change log
| Date       | Version  | Description     |
|------------|----------|-----------------|
| xx-xx-2015 |  0.1.0   | Release         |

##Licence
MIT Open source
