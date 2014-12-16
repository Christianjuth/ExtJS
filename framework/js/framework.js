(function() {
  var framework;

  framework = {
    ini: function() {
      this.browser = this.getBrowser();
      if (typeof localStorage.options === "undefined" && this.browser === "chrome") {
        return localStorage.options = JSON.stringify({});
      }
    },
    getBrowser: function() {
      var browser;
      if (/Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor)) {
        browser = "chrome";
      }
      if (/OPR/.test(navigator.userAgent) && /Opera Software/.test(navigator.vendor)) {
        browser = "chrome";
      } else if (/Safari/.test(navigator.userAgent) && /Apple Computer/.test(navigator.vendor)) {
        browser = "safari";
      }
      return browser;
    },
    storage: {
      ini: function() {},
      set: function(key, value) {
        return localStorage[key] = value;
      },
      get: function(key) {
        return localStorage[key];
      },
      remove: function(key) {
        return localStorage.removeItem(key);
      },
      removeAll: function(exceptions) {
        var item, _i, _len, _ref, _results;
        _ref = this.dump();
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          item = _ref[_i];
          if (item !== "options") {
            _results.push(this.remove(item));
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      },
      dump: function() {
        var data, i, _i, _len;
        data = new Array();
        for (_i = 0, _len = localStorage.length; _i < _len; _i++) {
          i = localStorage[_i];
          if (localStorage.key(_i) !== "options") {
            data.push(localStorage.key(_i));
          }
        }
        return data;
      }
    },
    options: {
      ini: function() {},
      set: function(key, value) {
        var options;
        if (framework.browser === "chrome") {
          options = $.parseJSON(localStorage.options);
          options[key] = value;
          localStorage.options = JSON.stringify(options);
        }
        if (framework.browser === "safari") {
          safari.extension.settings[key] = value;
        }
        return options[key];
      },
      get: function(key) {
        var options, requestedOption;
        if (framework.browser === "chrome") {
          options = $.parseJSON(localStorage.options);
          requestedOption = options[key];
        }
        if (framework.browser === "safari") {
          requestedOption = safari.extension.settings[key];
        }
        return requestedOption;
      },
      reset: function(key) {
        var optionReset, options;
        if (framework.browser === "chrome") {
          options = $.parseJSON(localStorage.options);
          $.ajax({
            url: "../../configure.json",
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
        }
        if (framework.browser === "safari") {
          optionReset = safari.extension.settings.removeItem(key);
        }
        return optionReset;
      },
      resetAll: function(exceptions) {
        $.ajax({
          url: "../../configure.json",
          dataType: 'json',
          async: false,
          success: function(data) {
            var item, _i, _len, _ref, _results;
            _ref = data.options;
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              item = _ref[_i];
              _results.push(framework.options.reset(item.key));
            }
            return _results;
          }
        });
        return localStorage.options;
      }
    },
    tabs: {
      ini: function() {},
      create: function(url, target_blank) {
        if (target_blank === true) {
          if (framework.browser === "chrome") {
            chrome.tabs.create({
              url: url,
              active: true
            });
          }
          if (framework.browser === "safari") {
            return safari.application.activeBrowserWindow.openTab().url = url;
          }
        } else {
          return window.location.href = url;
        }
      },
      dump: function(callback) {
        if (framework.browser === "chrome") {
          chrome.tabs.query({}, callback);
        }
        if (framework.browser === "safari") {
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
      indexOf: function(url, callback) {
        var outputTabs, tab, tabs, window, _i, _j, _len, _len1, _ref;
        if (framework.browser === "chrome") {
          chrome.tabs.query({}, function(tabs) {
            var outputTabs, tab, _i, _len;
            outputTabs = [];
            for (_i = 0, _len = tabs.length; _i < _len; _i++) {
              tab = tabs[_i];
              if (framework.regex.url(tab.url, url) !== false) {
                outputTabs.push(tab);
              }
            }
            callback(outputTabs);
            return true;
          });
        }
        if (framework.browser === "safari") {
          tabs = [];
          outputTabs = [];
          _ref = safari.application.browserWindows;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            window = _ref[_i];
            tabs = tabs.concat(window.tabs);
          }
          for (_j = 0, _len1 = tabs.length; _j < _len1; _j++) {
            tab = tabs[_j];
            if (typeof tab.url !== "undefined") {
              if (framework.regex.url(tab.url, url) !== false) {
                outputTabs.push(tab);
              }
            }
          }
          callback(outputTabs);
        }
        return url;
      }
    },
    notification: function(title, content, icon) {
      if (framework.browser === "chrome") {
        chrome.notifications.create("", {
          iconUrl: icon,
          type: "basic",
          title: title,
          message: content
        }, function() {});
      }
      if (framework.browser === "safari") {
        return new Notification(title, {
          body: content
        });
      }
    },
    menu: {
      ini: function() {},
      icon: {
        setIcon: function(url) {
          var iconUrl;
          if (framework.browser === "chrome") {
            chrome.browserAction.setIcon({
              path: chrome.extension.getURL("assets/icons/" + url)
            });
          }
          if (framework.browser === "safari") {
            iconUrl = safari.extension.baseURI + 'icons/' + url;
            return safari.extension.toolbarItems[0].image = iconUrl;
          }
        },
        click: function(callback) {
          if (framework.browser === "chrome") {
            chrome.browserAction.onClicked.addListener(function() {
              return callback();
            });
          }
          if (framework.browser === "safari") {
            return safari.application.addEventListener("command", function(event) {
              if (event.command === "icon-clicked") {
                return callback();
              }
            }, false);
          }
        },
        setBadge: function(number) {
          number = parseInt(number);
          if (framework.browser === "chrome") {
            if (number === 0) {
              number = "";
            }
            chrome.browserAction.setBadgeText({
              text: String(number)
            });
          }
          if (framework.browser === "safari") {
            safari.extension.toolbarItems[0].badge = number;
          }
          if (number === "") {
            number = 0;
          }
          return number;
        },
        getBadge: function(callback) {
          if (framework.browser === "chrome") {
            return chrome.browserAction.getBadgeText({}, callback);
          }
        }
      }
    },
    regex: {
      url: function(str, test) {
        test = test.replace("*", ".+");
        test = new RegExp("^" + test + "$", "g");
        return test.test(str.replace(/\/$/, ""));
      }
    }
  };

  define(function() {
    return framework;
  });

  if (typeof window === "object" && typeof window.document === "object") {
    window.framework = framework;
  }

}).call(this);
