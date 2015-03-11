#Understanding ExtJS
This project allows you to build extensions for Chrome, Safari, and Opera using the same code.

###No More Browser Compatibility Issues
Meet ExtJS. A simple framework for building one extension that runs on Chrome, Safari, and Opera. Unlike other tools that provide a similar service, the ExtJS framework will compile down to one extension that runs on three browsers. This is done using a core library that detects the browser and runs native code at runtime. Because of this, rather than creating messy marching generated code, your extension will be clean, have structure, and be 100% open source friendly.

![Alt text](https://d15chbti7ht62o.cloudfront.net/assets/003/390/366/a4bf4567d5cf6f779da19f4fd8c7e886_large.jpg?1425590852)

###Try Our Example Extension
Meet TabSaver, a simple extension that closes old tabs as you open new ones. Ever have 20+ tabs open because you do not close them as you go. TabSaver will find the oldest tab and close it. You can set the max amount of tabs allowed in setting. [Download TabSaver](http://code.ext-js.org/example-extensions/tab-saver.safariextension.zip)

![Alt text](https://d15chbti7ht62o.cloudfront.net/assets/003/391/471/3fcba38ba9b6e8cca15f42c0d049e4eb_large.png?1425602152)

###How it works
There are two main pieces to ExtJS. The first is the framework that is responsible for getting your extension to load in Chrome, Safari, and Opera. The second is the core library that is responsible for getting your extension to run on all these browsers. The core library is a collection of functions injected into each page of the extension as the "ext" object. This is the heart of ExtJS and is where we will do our dirty work. The core library comes with some built-in functionality such as defining and manipulating extension options, but to take advantage of the framework you must download plugins.

###ExtJS Plugins
Plugins create a sort of high-level API that when called detects the browser and picks the native functions to run. Meet the Notification plugin. This ExtJS plugin allows you to create desktop notifications, a task that is very different across browsers.

![Alt text](https://d15chbti7ht62o.cloudfront.net/assets/003/391/563/ff9a5425ab901737cf97b1cfe66b5335_large.png?1425602952)

###Javascript vs Coffeescript
While we encourage the use of Coffeescript, we understand not everyone is comfortable using it. An ExtJS extension can be built using Javascript or Coffeescript.

![Alt text](https://d15chbti7ht62o.cloudfront.net/assets/003/391/514/49951c687cd4e8b4c868c79fbcf1b2d3_large.png?1425602511)

###Compiling
The grunt compile task will compile CoffeeScript, resize required icons, create the manifest.json and Safari Plist files, and package your chrome extension for the store upload. The average compile time is just under 3 seconds. This is fast enough you can compile and reload the extension in the browser as you go without slowing you down.

![Alt text](https://d15chbti7ht62o.cloudfront.net/assets/003/389/125/c05069064306a7723462d5d4c5569ee0_large.png?1425579063)
