
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
      name: 'Tabs',
      version: '0.1.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      }
    },
    create: function(url, target_blank) {
      if (ext.browser === 'chrome' && target_blank) {
        return chrome.tabs.create({
          url: url,
          active: true
        });
      } else if (ext.browser === 'safari' && target_blank) {
        return safari.application.activeBrowserWindow.openTab().url = url;
      } else {
        return window.location.href = url;
      }
    },
    dump: function(callback) {
      if (ext.browser === 'chrome') {
        chrome.tabs.query({}, callback);
      } else if (ext.browser === 'safari') {
        setTimeout(function(callback) {
          var tabs, window, _i, _len, _ref;
          tabs = [];
          _ref = safari.application.browserWindows;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            window = _ref[_i];
            tabs = tabs.concat(window.tabs);
          }
          return callback(tabs);
        }, 0, callback);
      }
      return true;
    },
    indexOf: function(urlSearchSyntax, callback) {
      var outputTabs, tab, tabs, url, window, _i, _j, _len, _len1, _ref;
      tabs = [];
      outputTabs = [];
      if (ext.browser === 'chrome') {
        chrome.tabs.query({}, function(tabs) {
          var tab, url, _i, _len;
          for (_i = 0, _len = tabs.length; _i < _len; _i++) {
            tab = tabs[_i];
            url = tab.url.replace(/(\/)$/, '');
            if (ext.match.url(url, urlSearchSyntax) !== false) {
              outputTabs.push(tab);
            }
          }
          return callback(outputTabs);
        });
      } else if (ext.browser === 'safari') {
        _ref = safari.application.browserWindows;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          window = _ref[_i];
          tabs = tabs.concat(window.tabs);
        }
        for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
          tab = tabs[_j];
          if (tab.url != null) {
            url = tab.url.replace(/(\/)$/, '');
            if (ext.match.url(url, urlSearchSyntax) !== false) {
              outputTabs.push(tab);
            }
          }
        }
        callback(outputTabs);
      }
      return urlSearchSyntax;
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

//# sourceMappingURL=tabs.js.map
