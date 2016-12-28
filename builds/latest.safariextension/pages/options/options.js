(function() {
  require(["jquery", "underscore", "mustache", "bootstrap", "ext", "extPlugin/notification"], function($, _, Mustache, bootstrap, ext) {
    var option;
    ext.ini();
    option = {
      create: function(json) {
        var elm, item, type;
        type = json.type.toLocaleLowerCase();
        try {
          item = this.types[type](json);
        } catch (_error) {
          throw new Error("Setting type " + json.type + " does not exsist");
        }
        elm = Mustache.render($("#option").html(), {
          title: json.title,
          option: item
        });
        elm = $(elm).appendTo("#settings");
        elm.find("input[type=text], textarea").keyup(function() {
          return ext.options.set(json.key, $(this).val());
        });
        elm.find("select").change(function() {
          return ext.options.set(json.key, $(this).val());
        });
        return elm.find("input[type=checkbox]").change(function() {
          return ext.options.set(json.key, $(this).is(':checked'));
        });
      },
      types: {
        text: function(json) {
          var elm;
          return elm = Mustache.render($("#text").html(), {
            value: ext.options.get(json.key)
          });
        },
        textarea: function(json) {
          var elm;
          return elm = Mustache.render($("#textarea").html(), {
            text: ext.options.get(json.key)
          });
        },
        checkbox: function(json) {
          var checked, elm;
          checked = String(ext.options.get(json.key)) === "true";
          return elm = Mustache.render($("#checkbox").html(), {
            sel: checked
          });
        },
        list: function(json) {
          var current, elm, inx;
          current = ext.options.get(json.key);
          inx = 0;
          _.find(json.options, function(obj, INX) {
            if (String(obj.val) === current) {
              return inx = INX;
            }
          });
          json.options[inx].sel = true;
          return elm = Mustache.render($("#select").html(), {
            current: current,
            options: json.options
          });
        }
      }
    };
    return ext._.getConfig(function(data) {
      var item, _i, _len, _ref, _results;
      _ref = data.options;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(option.create(item));
      }
      return _results;
    });
  });

}).call(this);

//# sourceMappingURL=options.js.map
