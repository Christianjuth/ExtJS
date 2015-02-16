(function() {
  var defultOptions, ext;

  defultOptions = {
    silent: false
  };

  ext = {
    chrome: function(callback) {
      var ok, usage;
      usage = 'callback function';
      ok = ext._.validateArg(arguments, ['function'], usage);
      if (ok != null) {
        throw new Error(ok);
      }
      if (ext._.browser === 'chrome') {
        return callback();
      }
    },
    ini: function(options) {
      options = $.extend(defultOptions, options);
      ext._.options = options;
      ext._.onload();
      return window.ext;
    },
    _: {
      version: '0.1.0',
      internal: [],
      browser: (function() {
        var browser, userAgent, vendor;
        userAgent = navigator.userAgent;
        vendor = navigator.vendor;
        if (/Chrome/.test(userAgent) && /Google Inc/.test(vendor)) {
          browser = 'chrome';
        } else if (/Safari/.test(userAgent) && /Apple Computer/.test(vendor)) {
          browser = 'safari';
        } else if (/OPR/.test(userAgent) && /Opera Software/.test(vendor)) {
          browser = 'chrome';
        }
        return browser;
      })(),
      onbeforeload: function(ext) {
        var Keys, alias, item, msg, name, _i, _j, _len, _len1, _ref, _ref1, _results;
        Keys = Object.keys(ext);
        Keys.splice(Keys.indexOf('_'), 1);
        ext._.internal = Keys;
        if ((localStorage.options == null) && ext._.browser === 'chrome') {
          localStorage.options = JSON.stringify({});
        }
        ext._.options = defultOptions;
        _ref = ext._.internal;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item !== '_') {
            item = ext[item];
            if ((item._ != null) && (item._.aliases != null)) {
              name = item._.name;
              _ref1 = item._.aliases;
              for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
                alias = _ref1[_j];
                if (ext[alias] == null) {
                  ext[alias] = item;
                } else {
                  msg = 'ExtJS can\'t define alias "' + alias + '"';
                  ext._.log.warn(msg);
                }
              }
            }
            if ((item._ != null) && (item._.onload != null)) {
              _results.push(item._.onload());
            } else {
              _results.push(void 0);
            }
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      onload: function() {
        ext._.log = {};
        if (ext._.options.silent !== true) {
          ext._.log.info = (function() {
            return Function.prototype.bind.call(console.info, console);
          })();
          ext._.log.warn = (function() {
            return Function.prototype.bind.call(console.warn, console);
          })();
        } else {
          ext._.log.info = function() {};
          ext._.log.warn = function() {};
        }
        return ext._.log.error = (function() {
          return Function.prototype.bind.call(console.error, console);
        })();
      },
      validateArg: function(args, expected, usage) {
        var arg, i, type, types, valid, _i, _j, _len, _len1;
        usage = 'does not match usage function(' + usage + ')';
        for (i = _i = 0, _len = expected.length; _i < _len; i = ++_i) {
          arg = expected[i];
          arg = args[i];
          if (expected[i] != null) {
            types = expected[i].split(',');
            valid = false;
            for (_j = 0, _len1 = types.length; _j < _len1; _j++) {
              type = types[_j];
              if (typeof arg === type) {
                valid = true;
                break;
              }
            }
            if (!valid) {
              return usage;
            }
          }
        }
        return void 0;
      },
      getConfig: function(callback) {
        var async, json, ok, usage;
        usage = 'callback function';
        ok = ext._.validateArg(arguments, ['function,undefined'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (callback != null) {
          async = true;
        } else {
          async = false;
        }
        json = '';
        $.ajax({
          url: '../../configure.json',
          dataType: 'json',
          async: async,
          success: function(data) {
            json = data;
            if (callback != null) {
              return callback(json);
            }
          }
        });
        return json;
      },
      getDefaultIcon: function() {
        var json, output;
        json = ext._.getConfig();
        output = {};
        if ((json.menuIcon == null) || ((json.menuIcon['16'] == null) && (json.menuIcon['19'] == null))) {
          throw Error('no default icons set in configure.json');
        } else if ((json.menuIcon['19'] == null) && (json.menuIcon['16'] != null)) {
          json.menuIcon['19'] = json.menuIcon['16'];
        } else if ((json.menuIcon['16'] == null) && (json.menuIcon['19'] != null)) {
          json.menuIcon['16'] = json.menuIcon['19'];
        }
        output['19'] = json.menuIcon['19'];
        output['16'] = json.menuIcon['16'];
        return output;
      },
      run: function(fun) {
        var bk;
        bk = ext._.getBackground();
        fun = fun.bind(fun);
        return fun.call(bk.window);
      },
      getBackground: function() {
        var bk;
        bk = '';
        if (ext._.browser === 'chrome') {
          bk = chrome.extension.getBackgroundPage().window;
        }
        if (ext._.browser === 'safari') {
          bk = safari.extension.globalPage.contentWindow;
        }
        return bk;
      },
      backgroundProxy: function(fun) {
        var bk;
        bk = ext._.getBackground();
        return bk.ext._.run(fun);
      },
      load: function(id, plugin) {
        var alias, bk, compatibility, msg, name, ok, usage, _i, _len, _ref;
        usage = 'id string, plugin object';
        ok = ext._.validateArg(arguments, ['string', 'object'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (plugin._ == null) {
          ext._.log.error('plugin missing header');
          return false;
        }
        name = plugin._.name;
        bk = ext._.getBackground();
        if (bk.window !== window && plugin._.background === true) {
          bk.ext._.load(id, plugin);
        }
        if (plugin._.onbeforeload != null) {
          plugin._.onbeforeload(plugin);
        }
        ext[id] = plugin;
        if (plugin._.onload != null) {
          plugin._.onload(ext._.options);
        }
        if (plugin._.aliases != null) {
          _ref = plugin._.aliases;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            alias = _ref[_i];
            if (ext[alias] == null) {
              ext[alias] = ext[id];
            } else {
              msg = 'Ext plugin "' + name + '" can\'t define alias "' + alias + '"';
              ext._.log.warn(msg);
            }
          }
        }
        if (plugin._.compatibility != null) {
          compatibility = plugin._.compatibility;
          if (compatibility.chrome === 'none') {
            msg = 'Ext plugin "' + name + '" is Safari only';
            ext._.log.warn(msg);
          } else if (compatibility.chrome !== 'full') {
            msg = 'Ext plugin "' + name + '" may contain some Safari only functions';
            ext._.log.warn(msg);
          }
          if (compatibility.safari === 'none') {
            msg = 'Ext plugin "' + name + '" is Chrome only';
            return ext._.log.warn(msg);
          } else if (compatibility.safari !== 'full') {
            msg = 'Ext plugin "' + name + '" may contain some Chrome only functions';
            return ext._.log.warn(msg);
          }
        }
      },
      log: {
        info: function() {},
        warn: function() {},
        error: function() {}
      }
    },
    match: {
      url: function(url, urlSearchSyntax, options) {
        var escChars, negate, ok, output, test, usage;
        usage = 'url string, urlSearchSyntax, options object';
        ok = ext._.validateArg(arguments, ['string', 'string', 'object,undefined'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        defultOptions = {
          maxLength: '*',
          minLength: 0,
          ignorecase: true,
          require: ''
        };
        test = urlSearchSyntax;
        output = false;
        options = $.extend(defultOptions, options);
        url = url.replace(/\%20/i, ' ');
        negate = /^\!/.test(test);
        escChars = '{ , } /?';
        test = test.replace(/^\!/g, '');
        test = ext.parse.normalize(test);
        test = test.replace(/\$\$/g, '(\\$)');
        test = test.replace(/(\$)?\?/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '[^/]';
          }
        });
        test = test.replace(/(\*|\$)?\*/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return "([^/]+)*";
          }
        });
        test = test.replace(/\*\*/g, '.*?');
        test = test.replace(/\$\*/g, '\\*');
        test = test.replace(/(\$)?{/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '(';
          }
        });
        test = test.replace(/(\$)?}/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return ')';
          }
        });
        test = test.replace(/(\$)?,/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '|';
          }
        });
        escChars = escChars.replace(/\ /g, '|');
        escChars = new RegExp('\\$(?=(' + escChars + '))', 'g');
        test = test.replace(escChars, '');
        if (options.ignorecase) {
          test = new RegExp('^(' + test + ')$', 'gi');
        } else {
          test = new RegExp('^(' + test + ')$', 'g');
        }
        if (negate) {
          output = !test.test(url);
        } else {
          output = test.test(url);
        }
        if (options.maxLength !== '*') {
          output = output && url.length <= options.maxLength;
        }
        output = output && url.length >= options.minLength;
        output = output && url.contains(options.require);
        return output;
      },
      text: function(text, textSearchSyntax, options) {
        var escChars, negate, ok, output, test, usage;
        usage = 'url string, textSearchSyntax, options object';
        ok = ext._.validateArg(arguments, ['string', 'string', 'object,undefined'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        defultOptions = {
          allowSpaces: true,
          maxLength: '*',
          minLength: 0,
          require: '',
          ignorecase: true
        };
        test = textSearchSyntax;
        output = false;
        options = $.extend(defultOptions, options);
        negate = /^\!/.test(test);
        escChars = '{ , } /?';
        test = test.replace(/^\!/g, '');
        test = ext.parse.normalize(test);
        test = test.replace(/\$\$/g, '(\\$)');
        test = test.replace(/(\$)?\?/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '.';
          }
        });
        test = test.replace(/(\$)?\*/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '.*?';
          }
        });
        test = test.replace(/\$\*/g, '\\*');
        test = test.replace(/(\$)?{/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '(';
          }
        });
        test = test.replace(/(\$)?}/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return ')';
          }
        });
        test = test.replace(/(\$)?,/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return '|';
          }
        });
        escChars = escChars.replace(/\ /g, '|');
        escChars = new RegExp('\\$(?=(' + escChars + '))', 'g');
        test = test.replace(escChars, '');
        if (options.ignorecase) {
          test = new RegExp('^(' + test + ')$', 'gi');
        } else {
          test = new RegExp('^(' + test + ')$', 'g');
        }
        if (negate) {
          output = !test.test(text);
        } else {
          output = test.test(text);
        }
        if (!options.allowSpaces) {
          output = output && -1 === text.indexOf(" ");
        }
        if (options.maxLength !== '*') {
          output = output && text.length <= options.maxLength;
        }
        output = output && text.length >= options.minLength;
        output = output && text.contains(options.require);
        return output;
      }
    },
    menu: {
      setIcon: function(url) {
        var icon, iconUrl, ok, usage;
        usage = 'url string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        icon;
        if (ext._.browser === 'chrome') {
          icon = {
            path: chrome.extension.getURL('menu-icons/' + url + '-16.png')
          };
          chrome.browserAction.setIcon(icon);
        } else if (ext._.browser === 'safari') {
          iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png';
          safari.extension.toolbarItems[0].image = iconUrl;
        }
        return icon;
      },
      resetIcon: function() {
        var icon, iconUrl, icons;
        icons = ext._.getDefaultIcon();
        if (ext._.browser === 'chrome') {
          icon = {
            path: chrome.extension.getURL(icons['19'])
          };
          chrome.browserAction.setIcon(icon);
        } else if (ext._.browser === 'safari') {
          iconUrl = safari.extension.baseURI + icons['16'];
          safari.extension.toolbarItems[0].image = iconUrl;
        }
        return icon;
      },
      iconOnClick: function(callback) {
        var ok, usage;
        usage = 'callback function';
        ok = ext._.validateArg(arguments, ['function'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (ext._.getConfig().popup == null) {
          throw Error('can not define menu icon callback if popup is set in config');
        }
        if (ext._.browser === 'chrome') {
          return chrome.browserAction.onClicked.addListener(function() {
            return callback();
          });
        } else if (ext._.browser === 'safari') {
          return safari.application.addEventListener('command', function(event) {
            if (event.command === 'icon-clicked') {
              return callback();
            }
          }, false);
        }
      },
      setBadge: function(number) {
        var ok, usage;
        usage = 'number';
        ok = ext._.validateArg(arguments, ['number'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        number = parseInt(number);
        if (ext._.browser === 'chrome') {
          if (number === 0) {
            number = '';
          }
          chrome.browserAction.setBadgeText({
            text: String(number)
          });
          chrome.browserAction.setBadgeBackgroundColor({
            color: '#8E8E91'
          });
        } else if (ext._.browser === 'safari') {
          safari.extension.toolbarItems[0].badge = number;
        }
        if (number === '') {
          number = 0;
        }
        return number;
      },
      getBadge: function(callback) {
        var ok, output, usage;
        usage = 'callback function';
        ok = ext._.validateArg(arguments, ['function'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        output;
        if (ext._.browser === 'chrome') {
          output = chrome.browserAction.getBadgeText({}, callback);
        }
        if (ext._.browser === 'safari') {
          output = safari.extension.toolbarItems[0].badge;
        }
        return output;
      }
    },
    options: {
      _: {
        aliases: ['ops', 'opts'],
        background: true,
        changeBindings: [],
        bindChange: function(callback) {
          ext.options._.changeBindings.push(callback);
          console.log(ext.options._.changeBindings);
          return console.log(callback);
        },
        callChangeBindings: function() {
          var fun, _i, _len, _ref, _results;
          console.log(ext.options._.changeBindings);
          _ref = ext.options._.changeBindings;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            fun = _ref[_i];
            _results.push(fun());
          }
          return _results;
        },
        onload: function() {
          var data, option, _i, _len, _ref, _results;
          if (ext._.browser === 'chrome') {
            data = ext._.getConfig();
            _ref = data.options;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              option = _ref[_i];
              if (typeof ext.options.get(option.key) === 'undefined') {
                _results.push(ext.options.set(option.key, option["default"]));
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          }
        }
      },
      set: function(key, value) {
        var ok, options, usage;
        usage = 'key string, value';
        ok = ext._.validateArg(arguments, ['string', 'string,number,boolean,object'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (ext._.browser === 'chrome') {
          options = $.parseJSON(localStorage.options);
          options[key] = value;
          localStorage.options = JSON.stringify(options);
          ext.options._.callChangeBindings();
        } else if (ext._.browser === 'safari') {
          safari.extension.settings[key] = value;
        }
        return options[key];
      },
      get: function(key) {
        var ok, options, requestedOption, usage;
        usage = 'key string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (ext._.browser === 'chrome') {
          options = $.parseJSON(localStorage.options);
          requestedOption = options[key];
        } else if (ext._.browser === 'safari') {
          requestedOption = safari.extension.settings[key];
        }
        return requestedOption;
      },
      reset: function(key) {
        var ok, optionReset, options, usage;
        usage = 'key string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (ext._.browser === 'chrome') {
          options = $.parseJSON(localStorage.options);
          $.ajax({
            url: '../../configure.json',
            dataType: 'json',
            async: false,
            success: function(data) {
              options[key] = _.filter(data.options, {
                'key': key
              })[0]["default"];
              return localStorage.options = JSON.stringify(options);
            }
          });
          optionReset = options[key];
        } else if (ext._.browser === 'safari') {
          optionReset = safari.extension.settings.removeItem(key);
        }
        return optionReset;
      },
      resetAll: function(exceptions) {
        $.ajax({
          url: '../../configure.json',
          dataType: 'json',
          async: false,
          success: function(data) {
            var item, _i, _len, _ref, _results;
            _ref = data.options;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              item = _ref[_i];
              if (-1 === exceptions.indexOf(item.key)) {
                _results.push(ext.options.reset(item.key));
              } else {
                _results.push(void 0);
              }
            }
            return _results;
          }
        });
        return ext.options.dump();
      },
      dump: function() {
        var output;
        output = [];
        $.ajax({
          url: '../../configure.json',
          dataType: 'json',
          async: false,
          success: function(data) {
            var item, _i, _len, _ref, _results;
            _ref = data.options;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              item = _ref[_i];
              _results.push(output.push(item.key));
            }
            return _results;
          }
        });
        return output;
      },
      onChange: function(callback) {
        var bk, ok, usage;
        usage = 'callback function';
        ok = ext._.validateArg(arguments, ['function'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (ext._.browser === 'chrome') {
          bk = chrome.extension.getBackgroundPage().window;
          bk.$(window).bind('storage', function(e) {
            if (e.originalEvent.key === 'options') {
              return callback();
            }
          });
          bk.ext.options._.bindChange(callback);
        }
        if (ext._.browser === 'safari') {
          return safari.extension.settings.addEventListener('change', callback, false);
        }
      }
    },
    parse: {
      url: function(url) {
        var ok, protical, usage;
        usage = 'url string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (!ext.validate.url(url)) {
          throw Error('Invalid url');
        }
        protical = url.indexOf('https://') !== -1 && url.indexOf('https://') !== -1;
        if (!protical) {
          url = 'http://' + url;
        }
        return url;
      },
      array: function() {
        var input, item, output, _i, _len;
        output = [];
        input = arguments;
        for (_i = 0, _len = input.length; _i < _len; _i++) {
          item = input[_i];
          if (typeof item === "string") {
            output.push(item);
          } else {
            output = output.concat(item);
          }
        }
        return output;
      },
      id: function(id) {
        var ok, usage;
        usage = 'id string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        return id.toLowerCase().replace(/\ /g, "_");
      },
      normalize: function(text) {
        var ok, regexEscChars, usage;
        usage = 'string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        regexEscChars = '\\( \\) \\| \\. \\/ \\^ \\+ \\[ \\] \\- \\!';
        regexEscChars = regexEscChars.replace(/\ /g, '|');
        regexEscChars = new RegExp('(?=(' + regexEscChars + '))', 'g');
        text = text.replace(regexEscChars, '\\');
        return text;
      }
    },
    safari: function(callback) {
      var ok, usage;
      usage = 'callback function';
      ok = ext._.validateArg(arguments, ['function'], usage);
      if (ok != null) {
        throw new Error(ok);
      }
      if (ext._.browser === 'safari') {
        return callback();
      }
    },
    validate: {
      url: function(url) {
        var ok, usage;
        usage = 'url string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        return ext.match.url(url, '*{://,www.,://www.,}*.**');
      },
      secureUrl: function(url) {
        var ok, usage;
        usage = 'url string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        return ext.match.url(url, 'https://{www.,}*.**');
      },
      file: function(path, type) {
        var ok, usage;
        usage = 'path string, type string';
        ok = ext._.validateArg(arguments, ['string', 'string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        if (type != null) {
          return ext.match.url(path, 'file://**.' + type);
        } else {
          return ext.match.url(path, 'file://**');
        }
      },
      email: function(email) {
        var ok, usage;
        usage = 'email string';
        ok = ext._.validateArg(arguments, ['string'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        return ext.match.text(email, '*@*.*', {
          allowSpaces: false
        });
      },
      password: function(passwd, options) {
        var force, ok, usage;
        usage = 'passwd string, options object';
        ok = ext._.validateArg(arguments, ['string', 'object,undefined'], usage);
        if (ok != null) {
          throw new Error(ok);
        }
        defultOptions = {
          maxLength: 12,
          minLength: 5,
          require: ''
        };
        force = {
          allowSpaces: false,
          ignorecase: false
        };
        options = $.extend(defultOptions, options);
        $.extend(options, force);
        return ext.match.text(passwd, '*', options);
      }
    }
  };

  Array.prototype.compress = function() {
    var array, output;
    array = this;
    output = [];
    $.each(array, function(i, e) {
      if ($.inArray(e, output) === -1) {
        return output.push(e);
      }
    });
    return output;
  };

  String.prototype.compress = function() {
    return this.replace(/\ /g, '');
  };

  String.prototype.contains = function(textSearchSyntax) {
    var escChars, negate, output, test, tests, _i, _len;
    if (typeof textSearchSyntax === 'object') {
      tests = textSearchSyntax;
    } else {
      tests = [];
      tests.push(textSearchSyntax);
    }
    output = false;
    for (_i = 0, _len = tests.length; _i < _len; _i++) {
      test = tests[_i];
      negate = /^\!/.test(test);
      escChars = '{ , } /?';
      test = test.replace(/^\!/g, '');
      test = ext.parse.normalize(test);
      test = test.replace(/\$\$/g, '(\\$)');
      test = test.replace(/(\$)?\?/g, function($0, $1) {
        if ($1) {
          return $0;
        } else {
          return '.';
        }
      });
      test = test.replace(/(\$)?\*/g, function($0, $1) {
        if ($1) {
          return $0;
        } else {
          return '.*?';
        }
      });
      test = test.replace(/\$\*/g, '\\*');
      test = test.replace(/(\$)?{/g, function($0, $1) {
        if ($1) {
          return $0;
        } else {
          return '(';
        }
      });
      test = test.replace(/(\$)?}/g, function($0, $1) {
        if ($1) {
          return $0;
        } else {
          return ')';
        }
      });
      test = test.replace(/(\$)?,/g, function($0, $1) {
        if ($1) {
          return $0;
        } else {
          return '|';
        }
      });
      escChars = escChars.replace(/\ /g, '|');
      escChars = new RegExp('\\$(?=(' + escChars + '))', 'g');
      test = test.replace(escChars, '\\');
      test = new RegExp('^(.*?' + test + '.*?)$', 'gi');
      if (negate) {
        output = !test.test(this);
      } else {
        output = test.test(this);
      }
    }
    return output;
  };

  window.ext = ext;

  if (typeof window.define === 'function' && window.define.amd) {
    window.define('ext', ['jquery'], function() {
      ext._.onbeforeload(ext);
      window.ext;
      ext._.onload();
      return ext;
    });
  }

}).call(this);

//# sourceMappingURL=ext.js.map
