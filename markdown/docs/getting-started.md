#Getting Started

### Skills required
* **HTML**
* **CSS** - _LESS is also suggested_
* **Javascript** - _Coffeescript is also suggested_
* **jQuery** - _although this is not a direct requirement it is strongly suggested_
* **requireJS**
* **Chrome Extensions** - this will be a lot less confusing if you have some past experience

_I am only saying Chrome Extensions is because I am a Chrome Developer.  This framework is done the way I thing extensions should be built.  Because I prefer the Chrome method this whole framework is more Chrome oriented and requires very little Safari experience._


### Tools needed
* **IDE** - I suggest brackats.io
* **Terminal** - any UNIX-based terminal should work

_Personally, I use a Mac for development.  You can use Linux, but you will not be able to use Safari for obvious reasons._


### Get the framework
Start by cloning the hello world extension.  In an empty folder.
```
git clone https://github.com/Christianjuth/ExtJS_Framework.git
```


### First commit
We recommend doing an "ini" commit before making any changes.
```
git add .
git commit -m "ini"
git push origin master
```


### Start building
Now you can start editing your extension.  The actual extension in the app folder.  You have the choice between Javascript and Coffeescript.  The same goes for CSS and LESS.  You can even mix the two, but keep in mind, you can not have two files with the same name that are Javascript and Coffeescript _(e.g. main.js and main.coffee)_.  Again, the same goes for CSS and LESS.  The app will compile 1:1. This means the build folder is a complete copy of the app folder except your _.coffeescript_ and _.less_ files will be compiled to _.js_ and _.css_.  In addition to that, all Javascript files in the build folder will be minified using UglifyJS, and images will be compressed using the Grunt image minify plugin.

When linking to a LESS file you can add the path with a `<link>` tag keeping in mind you replace _.less_ with _.css_. You should not be using any `<script>` tags except for the one linking to the requireJS library.  All _.js_ files should be loaded through requireJS.

_Here is a very basic example of everything I have explained._
```
|-- app
|   |-- js
|   |   `-- main.coffee
|   |
|   |-- css
|   |   `-- style.less
|   |
|   `-- pages
|       `-- background
|           |-- background.html
|           `-- background.coffee
|
`-- builds
    `-- (compiled app)
```
_This is only scraping the surface. For more documentation reference the advanced guide._


### How do I compile my extension?
In the terminal run `grunt`. No joke that is literally all you do.

This will update your `builds` folder and the libraries packaged with this framework (_ext.js_, _jquery.js_, _require.js_, and _underscore.js_).


###How do I test my extension?
**Chrome**

1.  Go to `chrome://extensions/` in the address bar
2.  Check the box in the top right-hand corner that says `Developer Mode`
3.  Click `Load Unpacked Extension` and select the `builds/latest.safariextension` folder

_The reason, it has .safariextension, is so it can be loaded into Chrome or Safari for testing._

**Safari**

This is a little trickier than Chrome, but I will try and explain this best I can step by step.

1.  Open Safari's preferences
2.  Click on the Advanced tab - (Last tab on the right and a gear icon)
3.  Select the `Show Develop menu in menu bar` checkbox
4.  Close preferences
5.  Click the new dropdown, located in the menubar, that says `Develop`
6.  Click `Show Extension Builder` - (About half way down the dropdown)
7.  Click the plus in the bottom left and click `Add Extension`
8.  Select the `builds/latest.safariextension` and click `Select`
9.  Hit the install  button - (Located in the top right)
10. You are basically done. Click reload to update the extension as you code it.

_You may also need to restart Safari for some updates. This is probably a bug, but I find it has to be done some times_


### Uploading to store
**Chrome**

Assuming you already have a Google developer account, create a new extension, and upload the _.zip_ file found in the `builds` folder. _The name of the file should be a version number followed by `-chrome.zip`_ e.g. `0.1.0-chrome.zip`.
