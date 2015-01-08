## Example config

```javascript
// Note other configuration options can go in the files object, make sure that the first propery key value is the name and url.
grunt.initConfig({

  "browserDependencies": {
              "options": {},
              "labjs": {
                  "dir": "src/js/lib/labjs",
                  "files": [
                      {
                          "labjs-2.0.3.js": "https://raw.github.com/getify/LABjs/master/LAB.min.js"
                      },
                      {
                          "labjs-debug-2.0.3": "https://raw.github.com/getify/LABjs/master/LAB-debug.min.js"
                      }
                  ]
              },
              "jquery": {
                  "dir": "src/js/lib/jquery",
                  "files": [
                      {
                          "jquery-1.10.2.js": "http://code.jquery.com/jquery-1.10.2.js"
                      },
                      {
                          "jquery-2.0.3.js": "http://code.jquery.com/jquery-2.0.3.js"
                      }
                  ]
              },
              "jquery_plugins": {
                  "dir": "src/js/lib/jquery/plugins",
                  "files": [
                      {
                          "jquery.migrate-1.2.1.js": "http://code.jquery.com/jquery-migrate-1.2.1.js"
                      },
                      {
                          "jquery.XDomainRequest.js": "https://raw.github.com/MoonScript/jQuery-ajaxTransport-XDomainRequest/master/jQuery.XDomainRequest.js"
                      },
                      {
                          "jquery.serializeJSON-1.0.0.js": "https://raw.github.com/marioizquierdo/jquery.serializeJSON/1.0.0/jquery.serializeJSON.js"
                      },
                      {
                          "jquery.cookie-1.3.1.js": "https://raw.github.com/carhartl/jquery-cookie/v1.3.1/jquery.cookie.js"
                      },
                      {
                          "jquery.requestAnimationFrame-0.1.2.js": "https://raw.github.com/gnarf37/jquery-requestAnimationFrame/85a4ffffae9225c5e08c768aeadcaaa53eabdcbe/src/jquery.requestAnimationFrame.js"
                      },
                      {
                          "jquery.animate.enhanced-0.99.js": "https://raw.github.com/benbarnett/jQuery-Animate-Enhanced/9d83aaadcc94ea67c69344cb7815cb3ccb8a6c36/scripts/src/jquery.animate-enhanced.js"
                      },
                      {
                          "jquery.placeholder-2.0.7.js": "https://raw.github.com/mathiasbynens/jquery-placeholder/master/jquery.placeholder.js"
                      }
                  ]
              },
              "backbone": {
                  "dir": "src/js/lib/backbone",
                  "files": [
                      {
                          "backbone-1.0.0.js": "https://raw.github.com/documentcloud/backbone/1.0.0/backbone.js"
                      }
                  ]
              },
              "underscore": {
                  "dir": "src/js/lib/underscore",
                  "files": [
                      {
                          "underscore-1.5.1.js": "https://raw.github.com/jashkenas/underscore/1.5.1/underscore.js"
                      }
                  ]
              },
              "modernizr": {
                  "dir": "src/js/lib/modernizr",
                  "files": [
                      {
                          "modernizr-2.6.2.js": "https://raw.github.com/Modernizr/Modernizr/v2.6.2/modernizr.js"
                      }
                  ]
              },
              "mustache": {
                  "dir": "src/js/lib/mustache",
                  "files": [
                      {
                          "mustache-0.7.2.js": "https://raw.github.com/janl/mustache.js/0.7.2/mustache.js"
                      }
                  ]
              },
              "enquire": {
                  "dir": "src/js/lib/enquire",
                  "files": [
                      {
                          "enquire-2.0.0.js": "https://raw.github.com/WickyNilliams/enquire.js/v2.0.0/dist/enquire.js"
                      },
                      {
                          "match-media-polyfill.js": "https://raw.github.com/weblinc/media-match/master/media.match.js"
                      }
                  ]
              },
              "qunit": {
                  "dir": "test/qunit-1.11.0/lib",
                  "files": [
                      {
                          "qunit-1.11.0.js": "https://raw.github.com/jquery/qunit/v1.11.0/qunit/qunit.js"
                      },
                      {
                          "qunit-1.11.0.css": "https://raw.github.com/jquery/qunit/v1.11.0/qunit/qunit.css"
                      }
                  ]
              }
          }

});

grunt.registerTask('default', ['browserDependencies']);

```


