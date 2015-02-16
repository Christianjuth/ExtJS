define(['jquery', 'underscore', 'backbone', 'parse', 'js/router'], function($, _, Backbone, Parse, Router) {
  var initialize;
  Parse.initialize("kZS90MpRoWUMtFEgdt8kdWSejhl3thUb9GPdekpb", "ND73SsKVmvrxJ04LmLNgN2lqulJqdjqfRkvI6n23");
  initialize = function() {
    return Router.initialize();
  };
  return {
    initialize: initialize
  };
});
