
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
  var BROWSER, ID, NAME, PLUGIN, Tab, compare, log;

  PLUGIN = {
    _: {
      authors: ['Christian Juth'],
      name: 'Tabs',
      version: '0.1.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      },
      onload: function() {
        var TabWindow, id, tab, tabs, _i, _j, _len, _len1, _ref;
        if (BROWSER === 'safari') {
          id = 0;
          tabs = [];
          _ref = safari.application.browserWindows;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            TabWindow = _ref[_i];
            tabs = tabs.concat(TabWindow.tabs);
            for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
              tab = tabs[_j];
              if (tab.id == null) {
                tab.id = id++;
              }
            }
            tabs = tabs;
          }
          return ext.tabs.onCreate(function(tab) {
            var _k, _l, _len2, _len3, _ref1, _results;
            tabs = [];
            _ref1 = safari.application.browserWindows;
            _results = [];
            for (_k = 0, _len2 = _ref1.length; _k < _len2; _k++) {
              TabWindow = _ref1[_k];
              tabs = tabs.concat(TabWindow.tabs);
              for (_l = 0, _len3 = tabs.length; _l < _len3; _l++) {
                tab = tabs[_l];
                if (tab.id == null) {
                  tab.id = id++;
                }
              }
              _results.push(tabs = tabs);
            }
            return _results;
          });
        }
      }
    },
    get: function(id, callback) {
      if (BROWSER === 'chrome') {
        chrome.tabs.get(id, function(tab) {
          if (tab != null) {
            if (callback != null) {
              return callback(new Tab(tab));
            }
          }
        });
      }
      if (BROWSER === 'safari') {
        return ext.tabs.all(function(tabs) {
          var t, _i, _len, _results;
          _results = [];
          for (_i = 0, _len = tabs.length; _i < _len; _i++) {
            t = tabs[_i];
            if (t.id === id && (callback != null)) {
              _results.push(callback(new Tab(t)));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        });
      }
    },
    create: function(url, callback) {
      var defultOptions, options;
      defultOptions = {
        url: '**',
        pinned: false,
        active: false
      };
      if (typeof url !== "object") {
        url = {
          url: ext.parse.url(url)
        };
      } else {
        url.url = ext.parse.url(url.url);
      }
      options = $.extend(defultOptions, url);
      if (BROWSER === 'chrome') {
        chrome.tabs.create({
          url: options.url,
          pinned: options.pinned,
          active: options.active
        });
        if (callback != null) {
          return callback();
        }
      } else if (BROWSER === 'safari') {
        safari.application.activeBrowserWindow.openTab().url = options.url;
        if (callback != null) {
          return callback();
        }
      }
    },
    duplicate: function(id, callback) {
      return ext.tabs.get(id, function(tab) {
        return ext.tabs.create(tab, callback);
      });
    },
    query: function(urlSearch, callback) {
      var TabWindow, chromeQuery, defultOptions, options, outputTabs, tab, tabs, url, _i, _j, _len, _len1, _ref;
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      defultOptions = {
        url: '**'
      };
      if (typeof urlSearch !== "object") {
        urlSearch = {
          url: urlSearch
        };
      }
      options = $.extend(defultOptions, urlSearch);
      chromeQuery = {
        windowType: "normal"
      };
      if (options.pinned != null) {
        chromeQuery.pinned = options.pinned;
      }
      tabs = [];
      outputTabs = [];
      if (BROWSER === 'chrome') {
        chrome.tabs.query(chromeQuery, function(tabs) {
          var tab, url, _i, _len;
          for (_i = 0, _len = tabs.length; _i < _len; _i++) {
            tab = tabs[_i];
            url = tab.url.replace(/(\/)$/, '');
            if (ext.match.url(url, options.url) !== false) {
              outputTabs.push(new Tab(tab));
              outputTabs.sort(compare);
            }
          }
          return callback(outputTabs);
        });
      } else if (BROWSER === 'safari') {
        _ref = safari.application.browserWindows;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          TabWindow = _ref[_i];
          tabs = tabs.concat(TabWindow.tabs);
        }
        for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
          tab = tabs[_j];
          url = tabs.url;
          if (url == null) {
            url = '';
          }
          url = url.replace(/(\/)$/, '');
          if (ext.match.url(url, options.url) !== false) {
            outputTabs.push(new Tab(tab));
            outputTabs.sort(compare);
          }
        }
        callback(outputTabs);
      }
      return options.url;
    },
    all: function(callback) {
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      return ext.tabs.query('**', function(tabs) {
        return callback(tabs);
      });
    },
    active: function(callback) {
      var tab;
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      if (BROWSER === 'chrome') {
        chrome.tabs.query({
          active: true
        }, function(tab) {
          return callback(new Tab(tab[0]));
        });
      }
      if (BROWSER === 'safari') {
        tab = safari.application.activeBrowserWindow.activeTab;
        return callback(new Tab(tab));
      }
    },
    oldest: function(callback, search) {
      var defaultSearch, tabs;
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      defaultSearch = {
        url: '**'
      };
      search = $.extend(defaultSearch, search);
      return tabs = ext.tabs.query(search, function(tabs) {
        var oldest, tab, _i, _j, _len, _len1, _results;
        oldest = 9007199254740992;
        for (_i = 0, _len = tabs.length; _i < _len; _i++) {
          tab = tabs[_i];
          if (tab.id < oldest) {
            oldest = tab.id;
          }
        }
        _results = [];
        for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
          tab = tabs[_j];
          if (tab.id === oldest) {
            _results.push(callback(tab));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    },
    newest: function(callback, search) {
      var defaultSearch, tabs;
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      defaultSearch = {
        url: '**'
      };
      search = $.extend(defaultSearch, search);
      return tabs = ext.tabs.query(search, function(tabs) {
        var oldest, tab, _i, _j, _len, _len1, _results;
        oldest = -1;
        for (_i = 0, _len = tabs.length; _i < _len; _i++) {
          tab = tabs[_i];
          if (tab.id > oldest) {
            oldest = tab.id;
          }
        }
        _results = [];
        for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
          tab = tabs[_j];
          if (tab.id === oldest) {
            _results.push(callback(tab));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      });
    },
    go: function(id, url) {
      return ext.tabs.get(id, function(tab) {
        return tab.go(url);
      });
    },
    onCreate: function(callback) {
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      if (BROWSER === 'chrome') {
        chrome.tabs.onCreated.addListener(function(tab) {
          return callback(new Tab(tab));
        });
      }
      if (BROWSER === 'safari') {
        return safari.application.addEventListener('open', function(e) {
          var tab;
          tab = e.target;
          return callback(new Tab(tab));
        }, true);
      }
    },
    onDestroy: function(callback) {
      if (callback == null) {
        throw Error('Function requires a callback');
      }
      if (BROWSER === 'chrome') {
        chrome.tabs.onRemoved.addListener(function(tab) {
          return callback(new Tab(tab));
        });
      }
      if (BROWSER === 'safari') {
        return safari.application.addEventListener('close', function(e) {
          var tab;
          tab = e.target;
          return callback(new Tab(tab));
        }, true);
      }
    }
  };

  compare = function(a, b) {
    if (a.id < b.id) {
      return -1;
    }
    if (a.id > b.id) {
      return 1;
    }
    return 0;
  };

  Tab = function(tab) {
    var close;
    this.url = tab.url;
    this.title = tab.title;
    this.id = tab.id;
    this.pinned = tab.pinned;
    close = function() {
      return (function(tab) {
        return tab.close();
      })(tab);
    };
    this.duplicate = function() {
      return ext.tabs.duplicate(this.id);
    };
    this.destroy = function(force) {
      if (BROWSER === 'chrome') {
        chrome.tabs.remove(this.id);
      }
      if (BROWSER === 'safari') {
        return close();
      }
    };
    this.onActive = function(callback) {
      var id;
      id = this.id;
      if (BROWSER === 'chrome') {
        chrome.tabs.onActivated.addListener(function(e) {
          if (e.tabId === id) {
            return ext.tabs.get(e.tabId, callback);
          }
        });
      }
      if (BROWSER === 'safari') {
        return safari.application.addEventListener('activate', function(e) {
          tab = e.target;
          if (tab.id === id) {
            return callback(new Tab(tab));
          }
        }, true);
      }
    };
    this.go = function(url) {
      url = ext.parse.url(url);
      if (BROWSER === 'chrome') {
        chrome.tabs.update(this.id, {
          url: url
        });
      }
      if (BROWSER === 'safari') {
        tab.url = url;
      }
      return this.url = tab.url;
    };
    return this;
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
  
  https://github.com/Christianjuth/extension_framework/tree/plugin
   */

  BROWSER = '';

  NAME = PLUGIN._.name;

  ID = NAME.toLowerCase().replace(/\ /g, "_");

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

  if (typeof window.define === 'function' && window.define.amd) {
    window.define(['ext'], function(ext) {
      var VERSION;
      BROWSER = ext._.browser;
      if ((PLUGIN._.min == null) || PLUGIN._.min <= window.ext._.version) {
        return ext._.load(ID, PLUGIN);
      } else {
        VERSION = PLUGIN._.min;
        return console.error('Ext plugin (' + NAME + ') requires ExtJS v' + VERSION + '+');
      }
    });
  }

}).call(this);

//# sourceMappingURL=tabs.js.map
