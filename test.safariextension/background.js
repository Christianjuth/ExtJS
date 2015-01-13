require.config({

  baseUrl : '.',

  paths : {
    ext : 'js/framework/ext',
    jquery : 'js/libs/jquery',
    underscore : 'js/libs/underscore',
    plugins : 'js/plugins'
  }

});

require([
  "jquery",
  "underscore",
  "ext",
  "plugins/clipboard/clipboard",
  "plugins/notification/notification",
  "plugins/storage/storage",
  "plugins/tabs/tabs",
  "plugins/utilities/utilities",
  "plugins/uuid/uuid"
], function($,_,ext){
  ext.ini({
    silent : false
  });
});
