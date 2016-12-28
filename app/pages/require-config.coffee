#define library alialses
window.require  = {

  baseUrl : '../../'

  paths :
    jquery:         'bower/jquery/dist/jquery.min'
    bootstrap:      'bower/bootstrap/dist/js/bootstrap.min'
    underscore:     'bower/underscore/underscore-min'
    mustache:       'bower/mustache.js/mustache.min'
    ext:            'libs/ext'
    extPlugin:      'ext-plugins'

  shim :
    bootstrap: { "deps" :['jquery'] }
    extPlugin: { "deps" :['ext'] }

}
