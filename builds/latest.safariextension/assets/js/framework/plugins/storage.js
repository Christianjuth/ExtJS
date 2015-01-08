
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
  var id, log, name, plugin,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  plugin = {
    _info: {
      authors: ['Christian Juth'],
      name: 'Storage',
      version: '0.1.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      }
    },
    _aliases: ['localStorage', 'local'],
    _load: function() {
      if (localStorage.storage == null) {
        localStorage.storage = JSON.stringify({});
      }
      return $.ajax({
        url: '../../configure.json',
        dataType: 'json',
        async: false,
        success: function(data) {
          var item, _i, _len, _ref, _results;
          _ref = data.storage;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            item = _ref[_i];
            if (typeof ext.storage.get(item.key) === 'undefined') {
              _results.push(ext.storage.set(item.key, item["default"]));
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        }
      });
    },
    set: function(key, value) {
      var storage;
      storage = $.parseJSON(localStorage.storage);
      storage[key] = value;
      return localStorage.storage = JSON.stringify(storage);
    },
    get: function(key) {
      var storage;
      storage = $.parseJSON(localStorage.storage);
      return storage[key];
    },
    remove: function(key) {
      var storage;
      storage = $.parseJSON(localStorage.storage);
      delete storage[key];
      return localStorage.storage = JSON.stringify(storage);
    },
    removeAll: function(exceptions) {
      var item, _i, _len, _ref;
      _ref = ext.storage.dump();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if (__indexOf.call(exceptions, item) < 0) {
          ext.storage.remove(item);
        }
      }
      return ext.storage.dump();
    },
    dump: function() {
      var output;
      output = [];
      $.each($.parseJSON(localStorage.storage), function(key, val) {
        return output.push(key);
      });
      return output;
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
