#Notification Plugin



##Links
* [Coffeescript](http://code.ext-js.org/plugins/notification/notification.coffee)
* [Unminified](http://code.ext-js.org/plugins/notification/notification.js)
* [Minified](http://code.ext-js.org/plugins/notification/notification.min.js)

##Usage
This plugin gives the user a Chrome or Safari notification depending on the browser.  Both notification types work in and outside of the browser.  If the user is using a different application the notification will popup for a brief amount of time.

```javascript
//This function simply gives the
//user a notification.
ext.notification.basic("Title","Message...")

//This function will wait a inputed
//amount of time then notify then user.
//The max time is 50000 milliseconds.
ext.notification.delay ("Title","Message...", 50000)
```

##Change log
| Date       | Version  | Description     |
|------------|----------|-----------------|
| xx-xx-2015 |  0.1.0   | Release         |

##Licence
MIT Open source
