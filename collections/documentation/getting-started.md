#Getting Started

### Skills required
* **HTML/CSS/Javascript**
* **jQuery** - _although this is not a direct requirement it is strongly suggested_
* **requireJS**
* **Chrome Extensions** - this will be a lot less confusing if you have some past experience


### Tools needed
* **IDE** - I suggest brackats.io
* **Terminal or CMD**


### Get the framework
Start by cloning the hello world extension in an empty folder.
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

### Building your extension
We are not going to go over this in this particular guide because we am trying to cover just the "getting started" stuff. Please refer to [this guide](http://ext.js/documentation/hello-world-extension)


### How do I compile my extension?
In the terminal run `grunt`. Thats all you need to do.

This will update your `builds` folder and the libraries packaged with this framework (_ext.js_, _jquery.js_, _require.js_, and _underscore.js_).


###How do I test my extension?
**Chrome**

1.  Go to `chrome://extensions/` in the address bar
2.  Check the box in the top right-hand corner that says `Developer Mode`
3.  Click `Load Unpacked Extension` and select the `builds/latest.safariextension` folder

_The reason it has .safariextension is so it can be loaded into Chrome or Safari for testing._

**Safari**

This is a little trickier than Chrome, but we will try and explain the best we can step by step.

1.  Open Safari's preferences
2.  Click on the Advanced tab - (Last tab on the right and a gear icon)
3.  Select the `Show Develop menu in menu bar` checkbox
4.  Close preferences
5.  Click the new dropdown, located in the menubar, that says `Develop`
6.  Click `Show Extension Builder` - (About half way down the dropdown)
7.  Click the plus in the bottom left, and click `Add Extension`
8.  Select the `builds/latest.safariextension` and, click `Select`
9.  Hit the install  button - (Located in the top right)
10. You are basically done. Click reload to update the extension as you code it.

_You may also need to restart Safari for some updates. This is probably a bug, but we find it has to be done sometimes_
