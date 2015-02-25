[![npm version](https://badge.fury.io/js/grunt-extension-manifest.svg)](http://badge.fury.io/js/grunt-extension-manifest)
[![Build Status](https://travis-ci.org/Christianjuth/grunt-extension-manifest.svg?branch=master)](https://travis-ci.org/Christianjuth/grunt-extension-manifest)

# grunt-extension-manifest

> Compile one manifest for chrome and safari extensions.

## Getting Started
This plugin requires Grunt `~0.4.5`

```shell
npm install grunt-extension-manifest --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-extension-manifest');
```

## The "extension_manifest" task

### Overview
In your project's Gruntfile, add a section named `extension_manifest` to the data object passed into `grunt.initConfig()`.

### Options

#### options.file
Type: `String`
Default value: `'config.json'`

This is the location of the config file.

#### options.dest
Type: `String`
Default value: `'./'`

This is the destination folder of the compiled manifest.json, Info.plist, and Settings.plist.

### Usage Example
```js
grunt.initConfig({
  extension_manifest: {
    default: {
      file: 'configure.json',
      dest: './'
    }
  }
});
```

### Configure.json
```json
{
  "name" : "Your Extension",
  "author" : "John Smith",
  "version" : "0.2.2",
  "bundleID" : "com.yourcompany.extension",
  "databaseQuota" : "10",


  "description" : "This is awesome",
  "website" : "http://your-domain.com",


  "permissions" : [
    "secureWebsites",
    "websites",
    "notifications"
  ],

  "options_page": "options.html",
  "background" : "background.html",
  "popup" : "popup.html",


  "options" : [
    {
      "title" : "Full Name",
      "type" : "text",
      "key" : "name",
      "default": "John Smith"
    },
    {
      "title" : "Mailing List",
      "type" : "checkbox",
      "key" : "email",
      "default": true
    },
    {
      "title" : "What you want",
      "type" : "list",
      "key" : "list",
      "default": "all",
      "titles" : ["Food"],
      "values" : ["food"]
    }
  ]
}
```

## Release History
* 2015-01-13 v0.2.0 Stable Release
* 2015-01-13 v0.1.2 Bug Fixes
* 2015-01-12 v0.1.0 Release
