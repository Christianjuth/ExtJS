
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
  var BROWSER, ID, NAME, PLUGIN, encryptedStorage, log,
    __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  PLUGIN = {
    _: {
      authors: ['Christian Juth'],
      name: 'Encrypted Storage',
      aliases: ['enStore', 'enStorage'],
      version: '0.1.0',
      min: '0.1.0',
      compatibility: {
        chrome: 'full',
        safari: 'full'
      },
      github: '',
      onload: function() {
        var Default, encryptedStorage, item, storage, _i, _len, _results;
        Default = JSON.stringify({});
        encryptedStorage = ext._.getConfig().encryptedStorage;
        storage = {};
        if (localStorage.encryptedStorage == null) {
          localStorage.encryptedStorage = sjcl.encrypt('password', Default);
          _results = [];
          for (_i = 0, _len = encryptedStorage.length; _i < _len; _i++) {
            item = encryptedStorage[_i];
            log.info('storage item "' + item.key + '" default password is "password"');
            _results.push(ext.encrypted_storage.set(item.key, 'password', item["default"]));
          }
          return _results;
        }
      }
    },
    set: function(key, passwd, value) {
      var err, expected, ok, storage, usage;
      usage = 'key string, passwd string, value string';
      expected = ['string', 'string'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      storage = localStorage.encryptedStorage;
      try {
        storage = sjcl.decrypt(passwd, storage);
      } catch (_error) {
        err = _error;
        throw Error(err.message);
      }
      storage = $.parseJSON(storage);
      storage[key] = value;
      storage = sjcl.encrypt(passwd, JSON.stringify(storage));
      localStorage.encryptedStorage = storage;
      return void 0;
    },
    get: function(key, passwd) {
      var err, expected, ok, output, storage, usage;
      usage = 'key string, passwd string, value string';
      expected = ['string', 'string'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      output = '';
      storage = localStorage.encryptedStorage;
      try {
        storage = sjcl.decrypt(passwd, storage);
      } catch (_error) {
        err = _error;
        throw Error(err.message);
      }
      storage = $.parseJSON(storage);
      if (storage[key] == null) {
        throw Error('undefined item');
      }
      output = storage[key];
      return output;
    },
    changePasswd: function(Old, New) {
      var err, expected, ok, storage, usage;
      usage = 'oldPasswd string, newPasswd string';
      expected = ['string', 'string'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      storage = localStorage.encryptedStorage;
      try {
        storage = sjcl.decrypt(Old, storage);
      } catch (_error) {
        err = _error;
        throw Error(err.message);
      }
      storage = sjcl.encrypt(New, storage);
      return localStorage.encryptedStorage = storage;
    },
    remove: function(key, passwd) {
      var err, expected, ok, storage, usage;
      usage = 'key string, passwd string';
      expected = ['string', 'string'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      storage = localStorage.encryptedStorage;
      try {
        storage = sjcl.decrypt(passwd, storage);
      } catch (_error) {
        err = _error;
        throw Error(err.message);
      }
      storage = $.parseJSON(storage);
      delete storage[key];
      storage = sjcl.encrypt(passwd, JSON.stringify(storage));
      return localStorage.encryptedStorage = storage;
    },
    removeAll: function(passwd, exceptions) {
      var expected, item, ok, usage, _i, _len, _ref, _results;
      usage = 'passwd string, exceptions array';
      expected = ['string', 'object,undefined'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      _ref = ext.encrypted_storage.dump(passwd);
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        if ((exceptions == null) || __indexOf.call(exceptions, item) < 0) {
          _results.push(ext.encrypted_storage.remove(item, passwd));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    },
    dump: function(passwd) {
      var err, expected, ok, output, storage, usage;
      usage = 'passwd string';
      expected = ['string'];
      ok = ext._.validateArg(arguments, expected, usage);
      if (ok != null) {
        throw new Error(ok);
      }
      storage = localStorage.encryptedStorage;
      try {
        storage = sjcl.decrypt(passwd, storage);
      } catch (_error) {
        err = _error;
        throw Error(err.message);
      }
      storage = $.parseJSON(storage);
      output = [];
      $.each(storage, function(key, val) {
        return output.push(key);
      });
      return output;
    }
  };

  encryptedStorage = [];


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

//# sourceMappingURL=encrypted_storage.js.map
