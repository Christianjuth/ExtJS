module.exports = (grunt) ->
  #Load extension config file
  config = grunt.file.readJSON("configure.json")

  #Project functions
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),


    coffeelint :
      default: ['coffee/**/*.coffee']


    lesslint:
      src: ['less/**/*.less']


    less :
      default :
        options :
          compress: true

        files: [
          {
            expand: true,
            cwd: "less",
            src: ['**/*.less'],
            dest: "builds/latest.safariextension/assets/css/<%= srcDir %>/",
            ext: ".css"
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.less'],
            dest: "builds/latest.safariextension/views/<%= srcDir %>/",
            ext: ".css"
          }
        ]


    coffee :
      default :
        files: [
          {
            expand: true,
            cwd: "coffee",
            src: ['**/*.coffee'],
            dest: "builds/latest.safariextension/assets/js/<%= srcDir %>/",
            ext: ".js"
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.coffee'],
            dest: "builds/latest.safariextension/views/<%= srcDir %>/",
            ext: ".js"
          }
        ]


    uglify :
      options :
        compress :
          global_defs:
            "DEBUG": false
          dead_code: true

      default :
        files: [
          {
            expand: true,
            cwd: 'builds/latest.safariextension/assets/js/',
            src: '**/*.js',
            dest: 'builds/latest.safariextension/assets/js/<%= srcDir %>/'
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.js'],
            dest: "views/<%= srcDir %>/"
          }
        ]


    multiresize :
      default :
        src: 'icons/icon.png',
        dest: ['builds/latest.safariextension/icon-128.png', 'builds/latest.safariextension/icon-96.png','builds/latest.safariextension/icon-64.png','builds/latest.safariextension/icon-48.png','builds/latest.safariextension/icon-38.png','builds/latest.safariextension/icon-32.png', 'builds/latest.safariextension/icon-16.png'],
        destSizes: ['128x128', '96x96', '64x64', '48x48', '38x38', '32x32', '16x16']


    copy :
      package :
        src: ['**/*', '!**/builds/**', '!**/node_modules/**', '!Gruntfile.*', '!package.json', '!**/.git/**', '!**/coffee/**', '!**/less/**', '!**/icons/**', '!**/*.coffee', '!**/*.less'],
        expand: true,
        cwd: '.',
        dest: 'builds/latest.safariextension/'

      icons :
        src: ['**/*.jpg', '**/*.jpeg', '**/*.png'],
        expand: true,
        cwd: 'icons/menu-icons',
        dest: 'builds/latest.safariextension/assets/icons'

      archive :
        src: ['*.zip', '!' + config.version + '*'],
        expand: true,
        cwd: 'builds/',
        dest: 'builds/archive/'


    clean:
      latest : ['builds/latest.safariextension/**/*'],
      builds : ['builds/*.zip', '!builds/archive', '!builds/' + config.version + '*']


    compress :
      chrome :
        options :
          archive : 'builds/' + config.version + '-chrome.zip'
        src: ['**/*', '!Settings.plist', '!Info.plist', '!assets/icons/**/*-16.png', '!icon-96.png', '!icon-64.png', '!icon-32.png'],
        expand: true,
        cwd: 'builds/latest.safariextension/',
  }


  #load tasks
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-lesslint')
  grunt.loadNpmTasks('grunt-multiresize');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-newer');


  #register tasks
  grunt.registerTask 'debug', ['coffeelint','lesslint']
  grunt.registerTask 'img', ['multiresize', 'copy:icons']
  grunt.registerTask 'styles', ['less:default']
  grunt.registerTask 'scripts', ['coffee:default','uglify:default']
  grunt.registerTask 'package-chrome', ['compress:chrome']
  grunt.registerTask 'archive', ['copy:archive', 'clean:builds']


  #update new script and style files only
  grunt.registerTask 'default', [
    'newer:less:default',
    'newer:coffee:default',
    'newer:uglify:default'
  ]

  #update scripts, styles, images, and new files
  grunt.registerTask 'compile', [
    'copy:package',
    'img',
    'scripts'
    'styles'
  ]

  #clean all old files, rebuild, and package for store
  grunt.registerTask 'package', [
    'clean:latest',
    'compile'
    'package-chrome',
    'archive'
  ]
