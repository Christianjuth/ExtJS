
module.exports = (grunt) ->
  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    #lint functions
    coffeelint : default: ['plugin/**/*.coffee']

    #scripts and styles
    coffee :
      default :
        files :
          'dist/plugin.js' : [
            'plugin/licence.coffee',
            'plugin/plugin.coffee',
            'plugin/define.coffee'
          ]

    uglify :
      options :
        preserveComments : 'some'
      default :
        files :
          'dist/plugin.min.js' : 'dist/plugin.js'


    #other
    notify_hooks :
      options :
        enabled : true,
        max_jshint_notifications : 5,
        title : 'ExtJS Plugin Builder',
        success : true,
        duration : 3

  }

  #register tasks
  grunt.registerTask 'default', [
    'coffee'
    'uglify'
  ]

  grunt.task.run('notify_hooks')
