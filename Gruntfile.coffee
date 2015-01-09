
module.exports = (grunt) ->
  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    #lint functions
    coffeelint : default: ['plugin/**/*.coffee']

    #combine coffeescript files
    coffee :
      options :
        join: true
      default :
        files :
          'dist/plugin.js' : [
            'plugin/licence.coffee',
            'plugin/plugin.coffee',
            'plugin/define.coffee'
          ]

    #minify js files
    uglify :
      options :
        preserveComments : 'some'
      default :
        files :
          'dist/plugin.min.js' : 'dist/plugin.js'

    copy :
      default :
        expand: true,
        cwd: 'dist/'
        src: '**'
        dest: 'test/js/'


    #notify on task finish
    notify_hooks :
      options :
        enabled : true,
        max_jshint_notifications : 5,
        title : 'ExtJS Plugin Builder',
        success : true,
        duration : 3


    browserDependencies :
      define :
        dir : 'plugin',
        files: [
          {'define.coffee': 'https://raw.githubusercontent.com/Christianjuth/ExtJS_Library/plugin/plugin/define.coffee'}
        ]
      assets :
        dir : 'test/js',
        files: [
          {'jquery.js': 'https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js'}
          {'require.js': 'http://requirejs.org/docs/release/2.1.15/minified/require.js'}
          {'ext.js': 'https://raw.githubusercontent.com/Christianjuth/ExtJS_Library/master/ext.js'}
          {'underscore.js': 'http://underscorejs.org/underscore-min.js'}
        ]

    clean :
      default : [
        'plugin/define.coffee'
        'test/js/ext.js'
      ]

  }

  grunt.registerTask 'default', [
    'coffeelint'
#    'clean'
#    'browserDependencies'
    'coffee'
    'uglify'
    'copy'
  ]

  grunt.task.run('notify_hooks')
