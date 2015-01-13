/*
 * grunt-extension-manifest
 * https://github.com/christianjuth/grunt-extension-manifest
 *
 * Copyright (c) 2014 Christian Juth
 * Licensed under the MIT license.
 */

//THIS EXTENSION REQUIRES XMLDOM
//install with "npm install xmldom"

'use strict';

module.exports = function(grunt) {

  // Please see the Grunt documentation for more information regarding task
  // creation: http://gruntjs.com/creating-tasks

  grunt.registerMultiTask('extension_manifest', 'Compile one manifest for chrome and safari extensions.', function() {
    // Merge task-specific and/or target-specific options with these defaults.
    var options = this.options({
      file : "config.json",
      dest : "."
    });

    //get settings
    var json = grunt.file.readJSON(this.data.file);



    //create chrome manifest.json
    var chrome = {
      'manifest_version': 2,
      'name' : json.name,
      'author' : json.author,
      'version' : json.version,
      'description' : json.description,
      'homepage_url' : json.website,

      'browser_action' : {
        'default_icon' : {
          '19' : 'menu-icons/icon-19.png',
          '38' : 'icon-38.png'
        }
      },

      'background' : {
        'page' : json.background
      },

      permissions : [],

      'icons' : {
        '16' : 'icon-16.png',
        '48' : 'icon-48.png',
        '128' : 'icon-128.png'
      },

      'options_page' : json.options_page
    }

    if (json.popup != null) {
      chrome.browser_action.default_popup = json.popup;
    }



    //create safari info.plist
    var permissions = {
      'key' : 'Website Access',
      'dict' : {
        '#list' : [
          {
            'key' : 'Level',
          },
          {
            'key' : 'Include Secure Pages'
          }
        ]
      }
    }

    var secure = json.permissions.indexOf("secureWebsites") > -1
    var websites = json.permissions.indexOf("websites") > -1
    var notifications = json.permissions.indexOf("notifications") > -1

    if (secure) {
      permissions.dict['#list'][0]['string'] = 'All';
      permissions.dict['#list'][1]['true'] = '';
      chrome.permissions.push('tabs')
    } else if (websites) {
      permissions.dict['#list'][0]['string'] = 'All';
      permissions.dict['#list'][1]['false'] = '';
      chrome.permissions.push('tabs')
    } else {
      permissions.dict['#list'][0]['string'] = 'None';
      permissions.dict['#list'][1]['false'] = '';
    }

    if (notifications) {
      chrome.permissions.push('notifications');
    }

    var popup = {
      'dict' : {
        '#list' : [
          {
            'key' : 'Filename',
            'string' : json.popup
          },
          {
            'key' : 'Height',
            'real' : '400'
          },
          {
            'key' : 'Width',
            'real' : '400'
          },
          {
            'key' : 'Identifier',
            'string' : 'popup'
          }
        ]
      }
    }


    var menu = {
      'dict' : {
        '#list' : [
          {
            'key' : 'Command',
            'string' : ''
          },
          {
            'key' : 'Popover',
            'string' : 'popup'
          },
          {
            'key' : 'Identifier',
            'string' : 'popupID'
          },
          {
            'key' : 'Image',
            'string' : 'menu-icons/icon-16.png'
          },
          {
            'key' : 'Label',
            'string' : json.name
          }
        ]
      }
    }

    if (json.popup == null) {
      menu.dict['#list'][0]['string'] = 'icon-clicked';
      menu.dict['#list'][1]['string'] = '';
      delete popup.dict
    }

    var safari = {
      'plist' : {
        '@version' : '1.0',
        'dict' : {
          '#list' : [
            {
              'key' : 'Builder Version',
              'string' : '10600.2.5'
            },
            {
              'key' : 'CFBundleDisplayName',
              'string' : json.name
            },
            {
              'key' : 'CFBundleIdentifier',
              'string' : json.bundleID
            },
            {
              'key' : 'CFBundleInfoDictionaryVersion',
              'string' : '6.0'
            },
            {
              'key' : 'CFBundleShortVersionString',
              'string' : json.version
            },
            {
              'key' : 'CFBundleVersion',
              'string' : json.version
            },
            {
              'key' : 'Chrome',
              'dict' : {
                '#list' : [
                  {
                    'key' : 'Database Quota',
                    'real' : json.databaseQuota * 1048576
                  },
                  {
                    'key' : 'Global Page',
                    'string' : json.background
                  },
                  {
                    'key' : 'Popovers',
                    'array' : popup
                  },
                  {
                    'key' : 'Toolbar Items',
                    'array' : menu
                  }
                ]
              }
            },
            {
              'key' : 'Website',
              'string' : json.website
            },
            {
              'key' : 'Author',
              'string' : json.author
            },
            {
              'key' : 'Description',
              'string' : json.description
            },
            {
              'key' : 'Permissions',
              'dict' : permissions
            }
          ]
        }
      }
    }


    var settings = {
      'plist' : {
        'array' : {
          '@version' : '1.0',
          '#list' : []
        }
      }
    }

    for (var i=0; i<json.options.length; i++){
      var item = json.options[i]
      item.type = item.type.replace(/^(textArea)$/ig,'TextField');
      item.type = item.type.replace(/^(text)$/ig,'TextField');
      item.type = item.type.replace(/^(checkbox)$/ig,'CheckBox');
      item.type = item.type.replace(/^(list)$/ig,'ListBox');
      var jsomItem = {
        dict : {
          '#list' : [
            {
              'key' : 'DefaultValue'
            },
            {
              'key' : 'Titles',
              'array' : {
                '#list' : []
              }
            },
            {
              'key' : 'Values',
              'array' : {
                '#list' : []
              }
            },
            {
              'key' : 'Key',
              'string' : item.key
            },
            {
              'key' : 'Title',
              'string' : item.title
            },
            {
              'key' : 'Type',
              'string' : item.type
            }
          ]
        }
      }

      if(typeof item.default === "boolean"){
        jsomItem.dict['#list'][0][item.default] = ''
      } else {
        jsomItem.dict['#list'][0]['string'] = item.default
      }

      if (item.type === 'ListBox'){
        for(var j=0; j<item.values.length; j++){
          jsomItem.dict['#list'][1]['array']['#list'].push({
            'string' : item.titles[j]
          });

          jsomItem.dict['#list'][2]['array']['#list'].push({
            'string' : item.values[j]
          });
        }
      } else {
        delete jsomItem.dict['#list'][2]['array']['#list']
        delete jsomItem.dict['#list'][1]['array']['#list']
      }

      settings.plist.array['#list'].push(jsomItem)
    }


    var builder = require('xmlbuilder')

    var safari = builder.create(safari)
    .dec('1.0', 'UTF-8', true)
    .dtd("-//Apple//DTD PLIST 1.0//EN","http://www.apple.com/DTDs/PropertyList-1.0.dtd")
    .root()
    .end({ pretty: true });

    var settings = builder.create(settings)
    .dec('1.0', 'UTF-8', true)
    .dtd("-//Apple//DTD PLIST 1.0//EN","http://www.apple.com/DTDs/PropertyList-1.0.dtd")
    .root()
    .end({ pretty: true });



    // Write the destination file.
    grunt.file.write(this.data.dest + 'manifest.json', JSON.stringify(chrome, null, 2));
    grunt.file.write(this.data.dest + 'info.plist', safari);
    grunt.file.write(this.data.dest + 'settings.plist', settings);

    // Print a success message.
    grunt.log.ok('3 were created');
  });

};
