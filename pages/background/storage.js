(function() {
  var storage;

  storage = {
    ini: function() {
      return $.ajax({
        url: "../../configure.json",
        dataType: 'json',
        async: false,
        success: function(data) {
          var item, option, options, storedOptions, _i, _j, _len, _len1, _results;
          if (framework.browser === "chrome") {
            options = data.options;
            storedOptions = $.parseJSON(localStorage.options);
            for (_i = 0, _len = options.length; _i < _len; _i++) {
              option = options[_i];
              if (typeof storedOptions[option.key] === "undefined") {
                framework.settings.set(option.key, option["default"]);
              }
            }
          }
          storage = data.storage;
          _results = [];
          for (_j = 0, _len1 = storage.length; _j < _len1; _j++) {
            item = storage[_j];
            if (typeof localStorage[item.key] === "undefined") {
              _results.push(localStorage[item.key] = item["default"]);
            } else {
              _results.push(void 0);
            }
          }
          return _results;
        }
      });
    }
  };

  define(function() {
    return storage;
  });

  if (typeof window === "object" && typeof window.document === "object") {
    window.storage = storage;
  }

}).call(this);
