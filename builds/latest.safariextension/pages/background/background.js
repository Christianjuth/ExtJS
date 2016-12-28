(function() {
  window.message = "hey";

  require(["jquery", "ext", "extPlugin/uuid", "extPlugin/storage", "extPlugin/clipboard", "extPlugin/utilities", "extPlugin/tabs", "extPlugin/popup"], function($, ext) {
    return ext.ini();
  });

}).call(this);

//# sourceMappingURL=background.js.map
