module.exports = (grunt) ->

  #start time and load tasks
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    #resources
    browserDependencies:  grunt.file.readJSON('grunt/browserDependencies.json')

    #scripts
    coffeelint:           grunt.file.readJSON('grunt/coffeelint.json')
    coffee:               grunt.file.readJSON('grunt/coffee.json')
    uglify:               grunt.file.readJSON('grunt/uglify.json')

    #other
    copy:                 grunt.file.readJSON('grunt/copy.json')
    clean:                grunt.file.readJSON('grunt/clean.json')
    extension_manifest:   grunt.file.readJSON('grunt/extension_manifest.json')

  }

  #define tasks
  grunt.registerTask 'test', [
    'coffeelint'
  ]

  grunt.registerTask 'build', [
    #    'browserDependencies'
    'extension_manifest'
    'coffee'
    'clean'
    'uglify'
    'copy'
  ]

  #default grunt task
  grunt.registerTask 'default', [
    'test',
    'build'
  ]

  #notify when task is done
  grunt.task.run('notify_hooks')
