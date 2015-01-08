
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
        files: [{
          'define.coffee': 'https://raw.githubusercontent.com/Christianjuth/extension_framework/plugin/plugin/define.coffee'
        }]

    clean :
      define : ['plugin/define.coffee']

  }

  grunt.registerTask 'debug', [
    'coffeelint'
    'browserDependencies'
    'coffee'
  ]

  grunt.registerTask 'compile', [
    'browserDependencies:define'
    'coffee'
  ]

  #register tasks
  grunt.registerTask 'package', [
    'clean'
    'compile'
    'uglify'
  ]

  grunt.registerTask 'default', [
    'debug'
  ]

  grunt.task.run('notify_hooks')
