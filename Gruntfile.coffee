
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
        files: [{84
          'define.coffee': 'https://raw.githubusercontent.com/Christianjuth/ExtJS/plugin/plugin/define.coffee'
        }]

    clean :
      define : ['plugin/define.coffee']

  }

  grunt.registerTask 'default', [
    'coffeelint'
    'clean'
    'browserDependencies'
    'coffee'
    'uglify'
    'copy'
  ]

  grunt.task.run('notify_hooks')
