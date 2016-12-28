
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
  var BACKGROUND, BROWSER, ID, NAME, PLGDEFAULTOPTIONS, PLGOPTIONS, PLUGIN, log;

  PLUGIN = {
    _: {
      authors: ['Christian Juth'],
      name: 'Clipboard',
      aliases: ['clippy'],
      version: '0.5.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'none'
      }
    },
    write: function(text) {
      var copyFrom, input, output;
      input = text;
      output = input;
      copyFrom = $('<input/>');
      copyFrom.val(input);
      $('body').append(copyFrom);
      copyFrom.select();
      document.execCommand('copy');
      copyFrom.remove();
      return output;
    },
    read: function() {
      var input, output, pasteTo;
      input = "";
      output = "";
      pasteTo = $('<input/>');
      $('body').append(pasteTo);
      pasteTo.select();
      document.execCommand('paste');
      output = pasteTo.val();
      pasteTo.remove();
      return output;
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

//# sourceMappingURL=clipboard.js.map
