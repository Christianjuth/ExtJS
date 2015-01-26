
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
  var ID, NAME, log, plugin;

  plugin = {
    _info: {
      authors: ['Christian Juth'],
      name: 'Notification',
      version: '0.1.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      },
      github: ''
    },
    _aliases: ['noti'],
    basic: function(title, message) {
      if (ext.browser === 'chrome') {
        return chrome.notifications.create('', {
          iconUrl: chrome.extension.getURL('icon-128.png'),
          type: 'basic',
          title: title,
          message: message
        }, function() {});
      } else if (ext.browser === 'safari') {
        return new Notification(title, {
          body: message
        });
      }
    },
    delay: function(title, message, milliseconds) {
      if (50000 < parseInt(milliseconds)) {
        return log.error('timeout too long');
      } else {
        return setTimeout(function() {
          if (ext.browser === 'chrome') {
            return chrome.notifications.create('', {
              iconUrl: chrome.extension.getURL('icon-128.png'),
              type: 'basic',
              title: title,
              message: message
            }, function() {});
          } else if (ext.browser === 'safari') {
            return new Notification(title, {
              body: message
            });
          }
        }, milliseconds);
      }
    }
  };


  /*
  From the ExtJS team
  -------------------
  The code below was designed by the ExtJS team to provIDe useful info to the
  developers. We ask you do not change this code unless necessary. By keeping
  this standard on all plugins, we hope to make development easy by provIDing
  useful info to developers.  In addition to logging, the code below also
  contains the AMD function for defining the plugin.  This waits for the ExtJS
  AMD module to define the library itself, and then your plugin is defined
  which prevents any undefined errors.  Although not suggested, plugins can be
  loaded before the ExtJS library.  The functionality below assures ease of
  use.
  
  https://github.com/Christianjuth/extension_framework/tree/plugin
   */

  NAME = plugin._info.name;

  ID = NAME.toLowerCase().replace(/\ /g, "_");

  log = {
    error: function(msg) {
      return (function() {
        return ext._log.error('Ext plugin (' + NAME + ') says: ' + msg);
      })();
    },
    warm: function(msg) {
      return (function() {
        return ext._log.warn('Ext plugin (' + NAME + ') says: ' + msg);
      })();
    },
    info: function(msg) {
      return (function() {
        return ext._log.info('Ext plugin (' + NAME + ') says: ' + msg);
      })();
    }
  };

  if (typeof window.define === 'function' && window.define.amd) {
    window.define(['ext'], function() {
      var VERSION;
      if ((plugin._info.min == null) || plugin._info.min <= window.ext.version) {
        return window.ext[ID] = plugin;
      } else {
        VERSION = plugin._info.min;
        return console.error('Ext plugin (' + NAME + ') requires ExtJS v' + VERSION + '+');
      }
    });
  }

}).call(this);

//# sourceMappingURL=notification.js.map
