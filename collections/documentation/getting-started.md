#Getting Started

### Skills required
* HTML/CSS/Javascript
* jQuery - _although this is not a direct requirement it is strongly suggested_
* requireJS
* Chrome Extensions - this will be a lot less confusing if you have some past experience


### Tools needed
* IDE - I suggest brackats.io
* Terminal or CMD


### Getting the framework
Start by cloning Extension Framework
```shell
git clone https://github.com/Christianjuth/Extension Framework_Framework.git

#mac
brew install graphicsmagick

#linux
sudo apt-get install graphicsmagick
```

#### Windows
For windows you will need to install the GraphicsMagic.exe file. IMPORTANT We have not done windows testing yet and will update this info soon!
* [Windows 32bit](ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/GraphicsMagick-1.3.20-Q16-win32-dll.exe)
* [Windows 64bit](ftp://ftp.graphicsmagick.org/pub/GraphicsMagick/windows/GraphicsMagick-1.3.20-Q16-win64-dll.exe)

### Building your extension
We are not going to go over this in this particular guide because we am trying to cover just the "getting started" stuff. Please refer to [this guide](documentation/hello-world-extension)


### Compiling
In the terminal cd to the framework and run `grunt` and you are done. This will update your `builds` folder and the core library _ext.js_.

![Alt Text](http://code.ext-js.org/website/images/grunt-compile.png)


### Browser Testing
**Chrome**

1.  Go to `chrome://extensions/` in the address bar
2.  Check the box in the top right-hand corner that says `Developer Mode`
3.  Click `Load Unpacked Extension` and select and open the `builds/latest.safariextension` folder

![Alt Text](http://code.ext-js.org/website/images/chrome-load-extension.png)

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
8.  Select and open the `builds/latest.safariextension`
9.  Hit the install  button - (Located in the top right)
10. You are basically done. Click reload to update the extension as you code it.

![Alt Text](http://code.ext-js.org/website/images/safari-load-extension.gif)

_You may also need to restart Safari for some updates. This is probably a bug, but we find it has to be done sometimes_
