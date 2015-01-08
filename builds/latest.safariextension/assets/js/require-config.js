(function() {
  window.require = {
    baseUrl: '.',
    paths: {
      jquery: '../../libs/jquery-min',
      ext: '../../assets/js/framework/ext',
      underscore: '../../libs/underscore-min',
      bootstrap: '../../libs/bootstrap/js/bootstrap.min',
      extPlugin: '../../assets/js/framework/plugins',
      js: ''
    },
    shim: {
      "bootstrap": {
        "deps": ['jquery']
      }
    }
  };

}).call(this);
