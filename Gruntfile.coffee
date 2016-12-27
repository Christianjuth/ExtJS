
module.exports = (grunt) ->


  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)


  #Load extension config file
  config =             grunt.file.readJSON("app/configure.json")

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json'),
    
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
      libs: []
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
    'rsync'
    'sass'
    'coffee'
    'extension_manifest'
    'multiresize'
  ]

  # default task
  grunt.registerTask 'default', [
    'build'
    'watch'
  ]
