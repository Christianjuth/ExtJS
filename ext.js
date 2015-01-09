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
    ini: function(userOptions) {
      var options;
      options = $.extend(defultOptions, userOptions);
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
          item._load(userOptions);
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
      url: function(url, urlSearchSyntax) {
        var escChars, negate, output, regexEscChars, test;
        test = urlSearchSyntax;
        output = false;
        negate = /^\!/.test(test);
        regexEscChars = '\\( \\) \\| \\. \\/ \\^ \\+ \\[ \\] \\- \\!';
        escChars = '{ , }';
        test = test.replace(/^\!/g, '');
        regexEscChars = regexEscChars.replace(/\ /g, '|');
        regexEscChars = new RegExp('(?=(' + regexEscChars + '))', 'g');
        test = test.replace(regexEscChars, '\\');
        test = test.replace(/\$\$/g, '(\\$)');
        test = test.replace(/\?/g, '[^/]');
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
            return "(";
          }
        });
        test = test.replace(/(\$)?}/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return ")";
          }
        });
        test = test.replace(/(\$)?,/g, function($0, $1) {
          if ($1) {
            return $0;
          } else {
            return "|";
          }
        });
        escChars = escChars.replace(/\ /g, '|');
        escChars = new RegExp('\\$(?=(' + escChars + '))', 'g');
        test = test.replace(escChars, '');
        test = new RegExp('^(' + test + ')$', 'g');
        if (negate) {
          output = !test.test(url.replace(/\ /i, ''));
        } else {
          output = test.test(url.replace(/\ /i, ''));
        }
        return output;
      }
    },
    menu: {
      icon: {
        setIcon: function(url) {
          var icon, iconUrl;
          if (ext.browser === 'chrome') {
            icon = {
              path: chrome.extension.getURL('assets/icons/' + url)
            };
            return chrome.browserAction.setIcon(icon);
          } else if (ext.browser === 'safari') {
            iconUrl = safari.extension.baseURI + 'icons/' + url;
            return safari.extension.toolbarItems[0].image = iconUrl;
          }
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
          if (ext.browser === 'chrome') {
            return chrome.browserAction.getBadgeText({}, callback);
          }
        }
      }
    },
    options: {
      _aliases: ['ops', 'opts'],
      _load: function() {
        if (ext.browser === 'chrome') {
          return $.ajax({
            url: '../../configure.json',
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
              _results.push(ext.options.reset(item.key));
            }
            return _results;
          }
        });
        return localStorage.options;
      }
    },
    parse: {
      array: function() {
        var array, item, output, _i, _len;
        output = [];
        array = arguments;
        for (_i = 0, _len = array.length; _i < _len; _i++) {
          item = array[_i];
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

  window.ext = ext;

  if (typeof window.define === 'function' && window.define.amd) {
    window.define('ext', ['jquery'], function() {
      return window.ext;
    });
  }

}).call(this);
