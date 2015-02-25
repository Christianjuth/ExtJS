require.config({

  baseUrl : '.',

  paths : {
    ext :             '../../js/framework/ext',
    jquery :          '../../js/libs/jquery',
    underscore :      '../../js/libs/underscore',
    sjcl :            '../../js/libs/sjcl',
    plugins :         '../../js/plugins',
    js :              '../../js',
    test :            '../../js/test'
  }

});

require([
  "jquery",
  "underscore",
  "sjcl",
  "ext",
  "test",
  "plugins/clipboard/clipboard",
  "plugins/notification/notification",
  "plugins/storage/storage",
  "plugins/tabs/tabs",
  "plugins/utilities/utilities",
  "plugins/uuid/uuid",
  "plugins/encrypted_storage/encrypted_storage"
], function($,_,sljc,ext, test){
  ext.ini({
    verbose : true
  });
  errors = test.ini();
  if( errors === 0 ){
    console.info('Library testing finished with no issues.');
  } else {
    console.error('Library testing finished with ' + errors + ' errors.');
  }
});
