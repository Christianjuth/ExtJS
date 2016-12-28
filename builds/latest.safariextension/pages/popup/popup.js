(function() {
  require(["jquery", "mustache", "ext", "extPlugin/popup", "extPlugin/tabs", "extPlugin/notification"], function($, Mustache, ext) {
    ext.ini();
    return ext.popup.codeWrap(function() {
      ext.popup.setHeight(300);
      return ext.popup.setWidth(501);
    });
  });

}).call(this);

//# sourceMappingURL=popup.js.map
