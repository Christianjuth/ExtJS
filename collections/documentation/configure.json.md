# Configure.json
Lets break down every option we have to configure and what each does



### Basic example
```json
{
  "name" : "Save Me",
  "author" : "Christian Juth",
  "version" : "0.1.0",
  "bundleID" : "com.christianjuth.extension",
  "databaseQuota" : "1",
  "menuIcon" : {
    "19" : "menu-icons/icon-19.png",
    "16" : "menu-icons/icon-16.png"
  },

  "description" : "something",

  "permissions" : [
    "secureWebsites",
    "websites",
    "notifications"
  ],

  "background" : "pages/background/background.html",
  "options_page" : "pages/options/options.html",

  "storage" : [],

  "options" : [
    {
      "title" : "Max Tabs",
      "type" : "list",
      "key" : "maxTabs",
      "default": "10",
      "options": [
        {"title":"Five","val":5},
        {"title":"Ten","val":10},
        {"title":"Fifteen","val":15},
        {"title":"Twenty","val":20}
      ]
    }
  ]

}
```


### Required options
```json
{
  "name": "ExtJS",
  "author": "YOUR NAME",
  "version": "0.1.0",
  "bundleID": "org.ext-js.extension",
  "databaseQuota": "1",
  "menuIcon": {
    "19": "menu-icons/icon-19.png",
    "16": "menu-icons/icon-16.png"
  },

  "description": "",
  "website": "http://ext-js.org",

  "permissions": [],

  "background": "pages/background/background.html",

  "options": []
}

```

### All Options
```json
{
  "name": "ExtJS",
  "author": "YOUR NAME",
  "version": "0.1.0",
  "bundleID": "org.ext-js.extension",
  "databaseQuota": "1",
  "menuIcon": {
    "19": "menu-icons/icon-19.png",
    "16": "menu-icons/icon-16.png"
  },

  "description": "",
  "website": "http://ext-js.org",

  "permissions": [
    "secureWebsites",
    "websites",
    "notifications"
  ],

  "options_page": "pages/options/options.html",
  "background": "pages/background/background.html",
  "popup": "pages/popup/popup.html",

  "storage": [
    {
      "key": "data",
      "default":"123456789"
    }
  ],

  "options": [
    {
      "title": "Name",
      "type": "text",
      "key": "name",
      "default":"John"
    },
    {
      "title": "What you want",
      "type": "list",
      "key": "list",
      "default": 5,
      "options": [
        {"title":"Five", "val": 5},
        {"title":"Six", "val": 6}
      ]
    },
    {
      "title": "Respect Pinned",
      "type": "checkbox",
      "key":"pinned",
      "default": true
    },
    {
      "title": "A Message",
      "type": "textarea",
      "key":"message",
      "default": "Type Something..."
    }
  ]
}

```
