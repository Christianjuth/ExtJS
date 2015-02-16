(function() {
  require(["jquery", "underscore", "ext", "extPlugin/popup", "extPlugin/tabs", "extPlugin/notification"], function($, _, ext) {
    return ext.popup.codeWrap(function() {
      return alert();
    });
  });

}).call(this);
