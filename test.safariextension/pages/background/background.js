require.config({

  baseUrl : '../../',

  paths : {
    plugin :         'js/plugin',
    ext :            'js/ext',
    jquery :         'js/jquery',
    underscore :     'js/underscore-min'
  }

});

require([
  "jquery",
  "underscore",
  "ext",
  "plugin"
], function($,_,ext){
  ext.ini();
});
