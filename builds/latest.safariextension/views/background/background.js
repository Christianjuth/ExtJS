(function() {
  window.message = "hey";

  require(["jquery", "underscore", "ext", "extPlugin/storage", "extPlugin/clipboard", "extPlugin/extension", "extPlugin/notification", "extPlugin/tabs"], function($, _, ext) {
    ext.ini({
      silent: false
    });
    ext.menu.icon.setBadge(parseInt(ext.storage.get("google")));
    return ext.menu.icon.click(function() {
      return ext.tabs.indexOf("*.google.com", function(data) {
        if (data.length === 0) {
          ext.storage.set("google", parseInt(ext.storage.get("google")) + 1);
          ext.menu.icon.setBadge(ext.storage.get("google"));
          return ext.tabs.create("https://www.google.com", true);
        }
      });
    });
  });

}).call(this);
