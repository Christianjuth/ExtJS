#define library alialses
window.require  = {

  baseUrl : '.'

  paths :
    jquery :        '../../libs/jquery-min'
    ext :           '../../libs/ext'
    underscore :    '../../libs/underscore-min'
    mustache :      '../../libs/mustache.min'
    bootstrap :     '../../libs/bootstrap.min'
    extPlugin :     '../../ext-plugins'

  shim :
    "bootstrap" : { "deps" :['jquery'] }

}
