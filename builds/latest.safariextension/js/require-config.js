(function() {
  window.require = {
    baseUrl: '.',
    paths: {
      jquery: '../../js/libs/jquery-min',
      ext: '../../js/libs/ext',
      underscore: '../../js/libs/underscore-min',
      bootstrap: '../../js/libs/bootstrap/js/bootstrap.min',
      extPlugin: '../../ext-plugins',
      js: ''
    },
    shim: {
      "bootstrap": {
        "deps": ['jquery']
      }
    }
  };

}).call(this);
