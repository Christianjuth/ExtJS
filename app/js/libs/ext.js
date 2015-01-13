(function() {
  var defultOptions, ext;

  defultOptions = {
    silent: false
  };

  ext = {
    browser: '',
    version: '0.1.0',
    getBrowser: function() {
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
    },
    ini: function(options) {
      options = $.extend(defultOptions, options);
      this.browser = this.getBrowser();
      window.ext._config = options;
      if ((localStorage.options == null) && this.browser === 'chrome') {
        localStorage.options = JSON.stringify({});
      }
      $.each(ext, function(item) {
        var alias, compatibility, msg, name, _i, _len, _ref;
        item = window.ext[item];
        if (item._info != null) {
          name = item._info.name;
        } else {
          name = item;
        }
        if (item._load != null) {
          item._load(options);
          delete item._load;
        }
        if (item._aliases != null) {
          _ref = item._aliases;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            alias = _ref[_i];
            if (window.ext[alias] == null) {
              window.ext[alias] = item;
            } else if (options.silent !== true) {
              msg = 'Ext plugin "' + name + '" can\'t define alias "' + alias + '"';
              console.warn(msg);
            }
          }
          delete item._aliases;
        }
        if ((item._info != null) && options.silent !== true) {
          compatibility = item._info.compatibility;
          if (compatibility.chrome === 'none') {
            console.warn('Ext plugin "' + name + '" is Safari only');
          } else if (compatibility.chrome !== 'full') {
            msg = 'Ext plugin "' + name + '" may contain some Safari only functions';
            console.warn(msg);
          }
          if (compatibility.safari === 'none') {
            console.warn('Ext plugin "' + name + '" is Chrome only');
          } else if (compatibility.safari !== 'full') {
            msg = 'Ext plugin "' + name + '" may contain some Chrome only functions';
            console.warn(msg);
          }
        }
        return delete item._info;
      });
      return window.ext;
    },
    match: {
      url: function(url, urlSearchSyntax, options) {
        var escChars, negate, output, test;
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
        var escChars, negate, output, test;
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
        icon;
        var icon, iconUrl;
        if (ext.browser === 'chrome') {
          icon = {
            path: chrome.extension.getURL('menu-icons/' + url + '-16.png')
          };
          chrome.browserAction.setIcon(icon);
        } else if (ext.browser === 'safari') {
          iconUrl = safari.extension.baseURI + 'menu-icons/' + url + '-19.png';
          safari.extension.toolbarItems[0].image = iconUrl;
        }
        return icon;
      },
      resetIcon: function() {
        icon;
        var icon, iconUrl;
        if (ext.browser === 'chrome') {
          icon = {
            path: chrome.extension.getURL('menu-icons/icon-16.png')
          };
          chrome.browserAction.setIcon(icon);
        } else if (ext.browser === 'safari') {
          iconUrl = safari.extension.baseURI + 'menu-icons/icon-19.png';
          safari.extension.toolbarItems[0].image = iconUrl;
        }
        return icon;
      },
      click: function(callback) {
        if (ext.browser === 'chrome') {
          return chrome.browserAction.onClicked.addListener(function() {
            return callback();
          });
        } else if (ext.browser === 'safari') {
          return safari.application.addEventListener('command', function(event) {
            if (event.command === 'icon-clicked') {
              return callback();
            }
          }, false);
        }
      },
      setBadge: function(number) {
        number = parseInt(number);
        if (ext.browser === 'chrome') {
          if (number === 0) {
            number = '';
          }
          chrome.browserAction.setBadgeText({
            text: String(number)
          });
          chrome.browserAction.setBadgeBackgroundColor({
            color: '#8E8E91'
          });
        } else if (ext.browser === 'safari') {
          safari.extension.toolbarItems[0].badge = number;
        }
        if (number === '') {
          number = 0;
        }
        return number;
      },
      getBadge: function(callback) {
        output;
        var output;
        if (ext.browser === 'chrome') {
          output = chrome.browserAction.getBadgeText({}, callback);
        }
        if (ext.browser === 'safari') {
          output = safari.extension.toolbarItems[0].badge;
        }
        return output;
      }
    },
    options: {
      _aliases: ['ops', 'opts'],
      _load: function() {
        if (ext.browser === 'chrome') {
          return $.ajax({
            url: chrome.extension.getURL('configure.json'),
            dataType: 'json',
            async: false,
            success: function(data) {
              var option, _i, _len, _ref, _results;
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
          });
        }
      },
      set: function(key, value) {
        var options;
        if (ext.browser === 'chrome') {
          options = $.parseJSON(localStorage.options);
          options[key] = value;
          localStorage.options = JSON.stringify(options);
        } else if (ext.browser === 'safari') {
          safari.extension.settings[key] = value;
        }
        return options[key];
      },
      get: function(key) {
        var options, requestedOption;
        if (ext.browser === 'chrome') {
          options = $.parseJSON(localStorage.options);
          requestedOption = options[key];
        } else if (ext.browser === 'safari') {
          requestedOption = safari.extension.settings[key];
        }
        return requestedOption;
      },
      reset: function(key) {
        var optionReset, options;
        if (ext.browser === 'chrome') {
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
        } else if (ext.browser === 'safari') {
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
      }
    },
    parse: {
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
        return id.toLowerCase().replace(/\ /g, "_");
      },
      normalize: function(text) {
        var regexEscChars;
        regexEscChars = '\\( \\) \\| \\. \\/ \\^ \\+ \\[ \\] \\- \\!';
        regexEscChars = regexEscChars.replace(/\ /g, '|');
        regexEscChars = new RegExp('(?=(' + regexEscChars + '))', 'g');
        text = text.replace(regexEscChars, '\\');
        return text;
      }
    },
    validate: {
      url: function(url) {
        return ext.match.url(url, '*{://,www.,://www.,}*.**');
      },
      email: function(email) {
        return ext.match.text(email, '*@*.*', {
          allowSpaces: false
        });
      },
      password: function(passwd, options) {
        var force;
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
        return ext.match.text(passwd, '*', $.extend(options, force));
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
    return this.replace(/\ /, '');
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
      return window.ext;
    });
  }

}).call(this);

//# sourceMappingURL=ext.js.map
