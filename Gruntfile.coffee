module.exports = (grunt) ->


  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)


  #Load extension config file
  config = grunt.file.readJSON("app/configure.json")

  #Project functions
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json')
    
    watch:
      default:
        files: ["app/**/*"]
        tasks: ["build"]
        options:
          event: ["added", "changed"]

    #scripts
    coffee:
      options:
        sourceMap: true
      app:
        files: [
          expand: true
          cwd: "builds/latest.safariextension/pages"
          src: ["**/*.coffee"]
          dest: "builds/latest.safariextension/pages/"
          ext: ".js"
        ]
      framework:
        files:
          "dist/ext.js": [
            "coffee/framework/defaultOptions.coffee",
            "coffee/framework/header.coffee",
            "coffee/framework/vars.coffee",
            "coffee/framework/functions/*.coffee",
            "coffee/framework/footer.coffee",
            "coffee/framework/internal.coffee",
            "coffee/framework/global.coffee",
            "coffee/framework/define.coffee"
          ]
      plugins:
        files:
          "dist/plugins/clipboard.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/clipboard/clipboard.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/notification.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/notification/notification.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/storage.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/storage/storage.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/tabs.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/tabs/tabs.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/utilities.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/utilities/utilities.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/uuid.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/uuid/uuid.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/popup.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/popup/popup.coffee",
            "coffee/plugins/define.coffee"
          ],
          "dist/plugins/encrypted_storage.js": [
            "coffee/plugins/LICENSE.coffee",
            "coffee/plugins/encrypted_storage/encrypted_storage.coffee",
            "coffee/plugins/define.coffee"
          ]
      
    
    coffeelint: 
      app: ["app/**/*.coffee", "!app/js/libs/**/*.coffee"]
    sass:
      app:
        files: [{
          expand: true,
          cwd: 'builds/latest.safariextension/pages',
          src: '**/*.scss',
          dest: 'builds/latest.safariextension/pages',
          ext: '.css'
        }]

    #manage files
    clean:
      compile: [
        'builds/latest.safariextension/pages/**/*.coffee',
        'builds/latest.safariextension/pages/**/*.scss',
        'builds/latest.safariextension/pages/**/*.map'
      ]
    
    rsync:
      options: 
        recursive: true
      package:
        options:
          exclude: [
            "*.png",
            "Info.plist",
            "Settings.plist"]
          src: "app/"
          dest: "builds/latest.safariextension"
          delete: true
      icons:
        options:
          src: "app/menu-icons/"
          dest: "builds/latest.safariextension/menu-icons"
          delete: true
      ext:
        options:
          src: "dist/"
          dest: "builds/latest.safariextension/ext"
          delete: true

    #assets
    multiresize:
      default:
        src: "app/icon.png"
        dest: [
          "builds/latest.safariextension/icon-128.png",
          "builds/latest.safariextension/icon-96.png",
          "builds/latest.safariextension/icon-64.png",
          "builds/latest.safariextension/icon-48.png",
          "builds/latest.safariextension/icon-38.png",
          "builds/latest.safariextension/icon-32.png",
          "builds/latest.safariextension/icon-16.png"]
        destSizes: [
          "128x128",
          "96x96",
          "64x64",
          "48x48",
          "38x38",
          "32x32",
          "16x16"]

    #other
    extension_manifest:
      default:
        file: "app/configure.json"
        dest: "builds/latest.safariextension/"
    compress:
      chrome:
        options:
          archive: "builds/chrome.zip"
        src: ["**/*", "!Settings.plist", "!Info.plist", "!assets/icons/**/*-16.png", "!icon-96.png", "!icon-64.png", "!icon-32.png"]
        expand: true
        cwd: "builds/latest.safariextension/"

  }

  #register tasks
  grunt.registerTask 'test', [
    'coffeelint'
  ]

  grunt.registerTask 'build', [
    'clean'
    'rsync:package'
    'rsync:icons'
    'coffee'
    'sass'
    'rsync:ext'
    'extension_manifest'
    'multiresize'
  ]

  grunt.registerTask 'compile', [
    'build'
    'clean:compile'
    'compress'
  ]

  # default task
  grunt.registerTask 'default', [
    'build'
    'watch'
  ]