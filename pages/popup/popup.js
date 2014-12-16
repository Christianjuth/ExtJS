// Page: popup.html

//define library alialses
require.config({
  paths: {
    jquery: '../../assets/js/libs/jquery-min',
    framework: '../../framework',
    underscore : "../../assets/js/libs/underscore-min"
  }
});

//onload
require([
  "jquery",
  "framework/js/framework",
  "underscore"
], function($,framework,_){
  framework.ini()

  //your code here
});
