
/*!
The MIT License (MIT)

Copyright (c) 2014 Christian Juth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
 */

(function() {
  var BACKGROUND, BROWSER, ID, NAME, PLGDEFAULTOPTIONS, PLGOPTIONS, PLUGIN, log, validateLocation;

  PLUGIN = {
    _: {
      authors: ['Christian Juth'],
      name: 'Popup',
      version: '0.1.0',
      libMin: '0.1.0',
      background: false,
      compatibility: {
        chrome: 'full',
        safari: 'full'
      }
    },
    setWidth: function(width) {
      var expected, ok, usage;
      usage = 'width number';
      expected = ['number'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      validateLocation();
      if (BROWSER === 'chrome') {
        $('html, body').width(width);
      }
      if (BROWSER === 'safari') {
        return safari.self.width = width;
      }
    },
    setHeight: function(height) {
      var expected, ok, usage;
      usage = 'height number';
      expected = ['number'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      validateLocation();
      if (BROWSER === 'chrome') {
        $('html, body').height(height);
      }
      if (BROWSER === 'safari') {
        return safari.self.height = height;
      }
    },
    codeWrap: function(callback) {
      var expected, ok, usage;
      usage = 'callback function';
      expected = ['function'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      validateLocation();
      if (BROWSER === 'chrome') {
        callback();
      }
      if (BROWSER === 'safari') {
        return safari.application.addEventListener("popover", callback, true);
      }
    }
  };

  validateLocation = function() {
    var details, popup, valid;
    valid = false;
    if (BROWSER === 'safari') {
      details = safari.extension;
      if (details.popovers[0] != null) {
        popup = safari.extension.popovers[0].contentWindow;
        valid = window === popup.window;
      }
    }
    if (BROWSER === 'chrome') {
      details = chrome.app.getDetails();
      if (details.browser_action != null) {
        popup = chrome.app.getDetails().browser_action.default_popup;
        valid = ext.match.url(location.pathname, '{/,}' + popup);
      }
    }
    if (!valid) {
      throw Error('ext.popup.codeWrap() must be run from a popup');
    }
  };


  /*
  From the ExtJS team
  -------------------
  The code below was designed by the ExtJS team to providing useful info to the
  developers. We ask you do not change this code unless necessary. By keeping
  this standard on all plugins, we hope to make development easy by providing
  useful info to developers.  In addition to logging, the code below also
  contains the AMD function for defining the plugin.  This waits for the ExtJS
  AMD module to define the library itself, and then your plugin is defined
  which prevents any undefined errors.  Although not suggested, plugins can be
  loaded before the ExtJS library.  The functionality below assures ease of
  use.
  
  https://github.com/Christianjuth/ExtJS_Library/tree/plugin
   */

  BROWSER = '';

  NAME = PLUGIN._.name;

  ID = NAME.toLowerCase().replace(/\ /g, "_");

  if (PLUGIN._.options) {
    PLGDEFAULTOPTIONS = PLUGIN._.options;
  }

  PLGOPTIONS = function() {
    var output;
    if (PLUGIN._.defaultOptions) {
      output = $.extend(PLGDEFAULTOPTIONS, PLUGIN._.options);
    } else {
      throw Error('Plugin does not have options');
    }
    return optput;
  };

  PLUGIN.configure = function(opts) {
    return PLUGIN._.options = $.extend(PLGDEFAULTOPTIONS, opts);
  };

  log = {
    error: function(msg) {
      return (function() {
        msg = 'Ext plugin (' + NAME + ') says: ' + msg;
        return ext._.log.error(msg);
      })();
    },
    warn: function(msg) {
      return (function() {
        msg = 'Ext plugin (' + NAME + ') says: ' + msg;
        return ext._.log.warn(msg);
      })();
    },
    info: function(msg) {
      return (function() {
        msg = 'Ext plugin (' + NAME + ') says: ' + msg;
        return ext._.log.info(msg);
      })();
    }
  };

  if (PLUGIN._.background === true) {
    BACKGROUND = (function() {
      var bk;
      if (ext._.browser === 'chrome') {
        bk = chrome.extension.getBackgroundPage().window;
      }
      if (ext._.browser === 'safari') {
        bk = safari.extension.globalPage.contentWindow;
      }
      return bk;
    })();
  }

  if (typeof window.define === 'function' && window.define.amd) {
    window.define(['ext'], function(ext) {
      var VERSION;
      BROWSER = ext._.browser;
      if ((PLUGIN._.minLib == null) || PLUGIN._.minLib <= window.ext._.version) {
        return ext._.load(ID, PLUGIN);
      } else {
        VERSION = PLUGIN._.min;
        return log.error('Ext plugin (' + NAME + ') requires ExtJS v' + VERSION + '+');
      }
    });
  }

}).call(this);

//# sourceMappingURL=popup.js.map
