(function() {
  var test;

  test = {
    ini: function() {
      var errs, item, tests, _i, _len;
      errs = 0;
      tests = ['match', 'validate'];
      for (_i = 0, _len = tests.length; _i < _len; _i++) {
        item = tests[_i];
        if (!test[item]()) {
          console.error('Error with ext.' + [item]);
          errs = errs + 1;
        }
      }
      return errs;
    },
    match: function() {
      var valid;
      valid = ext.match.url('http://google.com', '*//google.*') && ext.match.url('http://plus.google.com', '*//plus.google.*') && !ext.match.url('http://google.com', '*//apple.*') && !ext.match.url('http://google.com', '!http://**');
      return valid;
    },
    validate: function() {
      var valid;
      valid = ext.validate.url('google.com') && ext.validate.url('http://google.com') && ext.validate.url('http://www.google.com') && !ext.validate.url('google') && !ext.validate.url('http://');
      return valid;
    }
  };

  window.test = test;

  if (typeof window.define === 'function' && window.define.amd) {
    window.define('test', ['ext'], function() {
      return window.test;
    });
  }

}).call(this);

//# sourceMappingURL=test.js.map
