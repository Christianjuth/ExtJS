#define library alialses
window.require  = {

  baseUrl : '.'

  paths :
    jquery :        '../../js/libs/jquery-min'
    ext :           '../../js/libs/ext'
    underscore :    '../../js/libs/underscore-min'
    mustache :      '../../js/libs/mustache.min'
    bootstrap :     '../../js/libs/bootstrap.min'
    extPlugin :     '../../ext-plugins'
    js :            '../../js'

  shim :
    "bootstrap" : { "deps" :['jquery'] }

}