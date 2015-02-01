
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
  var BROWSER, ID, NAME, PLUGIN, log;

  PLUGIN = {
    _: {
      authors: ['Christian Juth'],
      name: 'UUID',
      aliases: ['UUID'],
      version: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      },
      onload: function(options) {
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
    warm: function(msg) {
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
      if ((PLUGIN._.min == null) || PLUGIN._.min <= window.ext.version) {
        return ext._.load(ID, PLUGIN);
      } else {
        VERSION = PLUGIN._.min;
        return console.error('Ext plugin (' + NAME + ') requires ExtJS v' + VERSION + '+');
      }
    });
  }

}).call(this);

//# sourceMappingURL=uuid.js.map
