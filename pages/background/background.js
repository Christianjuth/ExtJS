(function() {
  require.config({
    paths: {
      jquery: "../../assets/js/libs/jquery-min",
      framework: "../../framework",
      underscore: "../../assets/js/libs/underscore-min"
    }
  });

  require(["jquery", "framework/js/framework", "underscore", "storage"], function($, framework, _, storage) {
    framework.ini();
    storage.ini();
    framework.menu.icon.setBadge(localStorage.google);
    return framework.menu.icon.click(function() {
      return framework.tabs.indexOf("*.google.com", function(data) {
        if (data.length === 0) {
          localStorage.google = parseInt(localStorage.google) + 1;
          framework.menu.icon.setBadge(localStorage.google);
          return framework.tabs.create("https://www.google.com", true);
        }
      });
    });
  });

}).call(this);
