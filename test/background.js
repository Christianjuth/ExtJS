require.config({

  baseUrl : '.',

  paths : {
    ext : 'js/ext',
    jquery : 'js/jquery',
    underscore : 'js/underscore'
  }

});

require([
  "jquery",
  "underscore",
  "ext",
], function($,_,ext){
  ext.ini({
    silent : false
  });
});
