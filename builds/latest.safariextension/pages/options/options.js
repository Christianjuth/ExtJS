(function() {
  require(["jquery", "underscore", "bootstrap", "ext", "extPlugin/extension"], function($, _, bootstrap, ext) {
    var option;
    ext.ini();
    option = {
      create: function(json) {
        var elm;
        elm = '<div class="row"><label class="col-sm-4 control-label right 400">' + json.title + '</label><div class="col-sm-8">' + this.types[json.type](json) + '</div></div>';
        elm = $(elm).appendTo("#settings");
        return elm.find("input, select").change(function() {
          return ext.options.set(json.key, $(this).val());
        });
      },
      types: {
        text: function(json) {
          var elm;
          return elm = '<input type="text" class="form-control" value="' + ext.options.get(json.key) + '">';
        },
        textArea: function(json) {
          var elm;
          return elm = '<textarea class="form-control" rows="4">' + ext.options.get(json.key) + '</textarea>';
        },
        checkbox: function(json) {
          var elm;
          if (String(ext.options.get(json.key)) === "true") {
            elm = '<input type="checkbox" checked>';
          } else {
            elm = '<input type="checkbox">';
          }
          return elm;
        },
        list: function(json) {
          var elm, storage, title, value, _i, _len, _ref;
          elm = '<select id="disabledSelect" class="form-control" value="' + ext.options.get(json.key) + '"></select>';
          _ref = json.titles;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            title = _ref[_i];
            value = json.values[_i];
            storage = ext.options.get(json.key);
            if (storage === value) {
              elm = $(elm).append('<option value="' + value + '" selected>' + title + '</option>');
            } else {
              elm = $(elm).append('<option value="' + value + '">' + title + '</option>');
            }
          }
          return elm.prop('outerHTML');
        }
      }
    };
    return $.getJSON("../../configure.json", function(data) {
      var item, _i, _len, _ref, _results;
      _ref = data.options;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        item = _ref[_i];
        _results.push(option.create({
          title: item.title,
          key: item.key,
          type: item.type,
          titles: item.titles,
          values: item.values
        }));
      }
      return _results;
    });
  });

}).call(this);
