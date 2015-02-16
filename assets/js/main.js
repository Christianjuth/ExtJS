require.config({
  baseUrl: "/",
  shim: {
    underscore: {
      exports: "_"
    },
    bootstrap: {
      deps: ["jquery"]
    },
    parse: {
      deps: ["jquery"],
      exports: "Parse"
    },
    sweetalert: {
      exports: "swal"
    },
    marked: {
      exports: "marked "
    },
    backbone: {
      deps: ["jquery", "underscore"],
      exports: "Backbone"
    }
  },
  paths: {
    jquery: "./assets/libs/jquery-min",
    mustache: "./assets/libs/mustache.min",
    underscore: "./assets/libs/underscore-min",
    backbone: "./assets/libs/backbone-min",
    templates: "./templates",
    bootstrap: "./assets/libs/bootstrap",
    highlight: "./assets/libs/highlight.pack",
    parse: "./assets/libs/parse",
    sweetalert: "./assets/libs/sweet-alert.min",
    marked: "./assets/libs/marked",
    js: "./assets/js"
  }
});

require(['js/app', 'js/responsive'], function(App) {
  return App.initialize();
});
