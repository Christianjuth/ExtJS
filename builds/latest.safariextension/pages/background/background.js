(function() {
  window.message = "hey";

  require(["jquery", "underscore", "extPlugin/uuid", "ext", "extPlugin/storage", "extPlugin/clipboard", "extPlugin/utilities", "extPlugin/tabs", "extPlugin/popup"], function($, _, yolo, ext) {
    ext.ini({
      silent: false
    });
    ext.menu.setBadge(parseInt(ext.storage.get("google")));
    return ext.menu.iconOnClick(function() {
      return ext.tabs.indexOf("htt*//plus.google.com**", function(data) {
        if (data.length === 0) {
          ext.storage.set("google", parseInt(ext.storage.get("google")) + 1);
          ext.menu.setBadge(ext.storage.get("google"));
          return ext.tabs.create("https://plus.google.com", true);
        } else {
          return console.log(data);
        }
      });
    });
  });

}).call(this);
