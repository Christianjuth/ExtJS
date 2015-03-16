#Hello world Extension
In this guide we will help you build your first extension with ExtJS step by step.


###Getting the framework
Start by cloning ExtJS
```shell
git clone https://github.com/Christianjuth/ExtJS_Framework.git

#not required but will make your life easer
brew install graphicsmagick
```

###Configuring your extension
Some of this is already set up but to help you understand how the config file works we are going to go over the important parts. Most of this should be pretty stright foward. This file replaces Chrome, Safari, and Opera config files so this is the only configuring you need to do.

Open `app/configure.json` and add the following
```json
{
  "name":        "Hello World",
  "description": "learning extjs",
  "developer":   "YOUR NAME",

  "background": "app/pages/background/background.html",
  "options":    "app/pages/options/options.html",
  "popup":      "app/pages/popup/popup.html"
}
```

###Creating a page
Lets start by creating a popup.

Open `app/pages/popup/popup.html` and add the following
```html
<h1>Hello YOUR NAME</h1>
```


###Testing
At this point you should be able to load your extension in all three browsers. If you do not know how to load your extension please [refrence this guide](documentation/getting-started#browser-testing).


###Creating some options
We define options in the ExtJS configure file.
Open `app/configure.json` and add the following
```json
options: [
  {
    "title":      "Your Name",
    "type":       "text",
    "key":        "name",
    "default":    "John Smith"
  }
]
```

Open `app/pages/popup/popup.html` and add the following
```html
<h1>Hello <span id="name"></span></h1>
```

Now lets make it work
Open `app/pages/popup/popup.coffee` and add the following
```coffee
#your code here
name = ext.options.get('name')
$('#name').text(name)
```
