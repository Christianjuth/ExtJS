module.exports = (grunt) ->

  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    coffeelint :
      default : [
        'coffee/**/*.coffee'
        '!coffee/header.coffee'
        '!coffee/footer.coffee'
      ]

    #combine coffeescript files
    coffee :
      options :
        join: true
        joinExt : '.coffee'
        sourceMap : true
      framework :
        files :
          'dist/framework/ext.js' : [
            'coffee/framework/options.coffee'
            'coffee/framework/header.coffee'
            'coffee/framework/vars.coffee'
            'coffee/framework/functions/*.coffee'
            'coffee/framework/footer.coffee'
            'coffee/framework/global.coffee'
            'coffee/framework/define.coffee'
          ]
      plugin : grunt.file.readJSON('grunt/coffee-plugin.json')
      default :
        files : [{
          "expand" : true,
          "cwd" : "coffee/",
          "src" : ["*.coffee"],
          "dest" : "test.safariextension/js"
          "ext" : '.js'
        }]


    browserDependencies :
      define :
        dir : 'coffee/plugins',
        files: [
          {'define.coffee': 'https://raw.githubusercontent.com/Christianjuth/ExtJS_Library/plugin/plugin/define.coffee'}
        ]

    #minify js files
    uglify :
      options :
        preserveComments : 'some'
      default :
        files : [{
          "expand" : true,
          "cwd" : "dist/",
          "src" : ["**/*.js"],
          "dest" : "dist/<%= srcDir %>"
          "ext" : '.min.js'
        }]

    copy :
      default :
        files : [{
          expand: true,
          cwd: 'dist/',
          src: '**/*',
          dest: 'test.safariextension/js/<%= srcDir %>',
          filter: 'isFile'
        }]

    clean : ['**/*.min.js']

    extension_manifest :
      default :
        file : 'test.safariextension/configure.json',
        dest : 'test.safariextension/'

  }

  grunt.registerTask 'default', [
#    'coffeelint:default'
    'browserDependencies:define'
    'extension_manifest'
    'coffee:framework'
    'coffee:plugin'
    'coffee:default'
#    'clean'
#    'uglify:default'
    'copy:default'
  ]

  grunt.task.run('notify_hooks')
