(function() {
  require(["jquery", "underscore", "bootstrap", "ext", "extPlugin/extension"], function($, _, bootstrap, ext) {
    var option;
    ext.ini();
    option = {
      create: function(json) {
        var elm;
        elm = '<div class="row"><label class="col-sm-4 control-label right 400">' + json.title + '</label><div class="col-sm-8">' + this.types[json.type](json) + '</div></div>';
        elm = $(elm).appendTo("#settings");
        return elm.find("input").change(function() {
          return ext.options.set(json.key, $(this).val());
        });
      },
      types: {
        text: function(json) {
          var elm;
          return elm = '<input type="text" class="form-control" value="' + ext.options.get(json.key) + '">';
        },
        number: function(json) {
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
        select: function(json) {
          var elm, item, _i, _len, _ref;
          elm = '<select id="disabledSelect" class="form-control"></select>';
          _ref = json.options;
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            item = _ref[_i];
            elm = $(elm).append('<option>' + item + '</option>');
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
          options: item.options
        }));
      }
      return _results;
    });
  });

}).call(this);
