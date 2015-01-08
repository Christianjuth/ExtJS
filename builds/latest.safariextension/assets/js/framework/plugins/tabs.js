
/*!
Licence - 2015
--------------------------------
This plugin is protected by the MIT licence and is open source.
I ask you do not remove and/or modify this copyright in any way.
This plugin is built separately from the ExtJS framework/library
and therefor falls under its own licence (MIT).  ExtJS and other
contributors can not claim ownership.  All contributors agree their
work is open source and falls under this plugins licence (MIT).

https://github.com/Christianjuth/
 */

(function() {
  var id, log, name, plugin;

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
            url = tab.url.replace(/\/$/, '');
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
            url = tab.url.replace(/\/$/, '');
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
  The code below was designed by the ExtJS team to provide useful info to the
  developers. We ask you do not change this code unless necessary. By keeping
  this standard on all plugins, we hope to make development easy by providing
  useful info to developers.  In addition to logging, the code below also
  contains the AMD function for defining the plugin.  This waits for the ExtJS
  AMD module to define the library itself, and then your plugin is defined
  which prevents any undefined errors.  Although not suggested, plugins can be
  loaded before the ExtJS library.  The functionality below assures ease of
  use. We also ask you keep this code up to date with any changes that may
  occur in the future.  Please refer to the sample plugin on the GitHub repo
  where this code is updated.
  
  https://github.com/Christianjuth/extension_framework/tree/plugin
   */

  name = plugin._info.name;

  id = name.toLowerCase().replace(/\ /g, "_");

  log = {
    error: function(msg) {
      return console.error('Ext plugin (' + name + ') says: ' + msg);
    },
    warn: function(msg) {
      return console.warn('Ext plugin (' + name + ') says: ' + msg);
    },
    info: function(msg) {
      return console.warn('Ext plugin (' + name + ') says: ' + msg);
    }
  };

  if (typeof window.define === 'function' && window.define.amd) {
    window.define(['ext'], function() {
      if ((plugin._info.min == null) || plugin._info.min <= window.ext.version) {
        return window.ext[id] = plugin;
      } else {
        return console.error('Ext plugin (' + name + ') requires ExtJS v' + plugin._info.min + '+');
      }
    });
  }

}).call(this);
