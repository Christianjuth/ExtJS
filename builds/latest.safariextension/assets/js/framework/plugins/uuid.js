
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
      name: 'UUID',
      version: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      }
    },
    _aliases: ['UUID'],
    _load: function(options) {
      var hexDigits, i, s, uuid;
      if (localStorage.uuid == null) {
        s = [];
        hexDigits = '0123456789abcdef';
        i = 0;
        while (i <= 36) {
          i++;
          s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
        }
        s[14] = '4';
        s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);
        s[9] = s[14] = s[19] = s[23] = '-';
        uuid = s.join('');
        if (options.silent !== true) {
          console.info('UUID "' + uuid + '" was created');
        }
        return localStorage.uuid = uuid;
      }
    },
    reset: function() {
      var hexDigits, i, options, s, uuid;
      options = window.ext._config;
      s = [];
      hexDigits = '0123456789abcdef';
      i = 0;
      while (i <= 36) {
        i++;
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
      }
      s[14] = '4';
      s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);
      s[9] = s[14] = s[19] = s[23] = '-';
      uuid = s.join('');
      if (options.silent !== true) {
        console.info('UUID was reset to "' + uuid + '"');
      }
      return localStorage.uuid = uuid;
    },
    get: function() {
      return localStorage.uuid;
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
