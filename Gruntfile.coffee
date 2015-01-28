
module.exports = (grunt) ->


  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)


  #Load extension config file
  config =             grunt.file.readJSON("app/configure.json")

  #Project functions
  grunt.initConfig {

  pkg: grunt.file.readJSON('package.json'),

  #styles
  less:                 grunt.file.readJSON('grunt/less.json')

  #scripts
  coffee:               grunt.file.readJSON('grunt/coffee.json')
  uglify:               grunt.file.readJSON('grunt/uglify.json')
  coffeelint:           grunt.file.readJSON('grunt/coffeelint.json')

  #manage files
  clean:                grunt.file.readJSON('grunt/clean.json')

  rsync:                grunt.file.readJSON('grunt/rsync.json')

  #assets
  imagemin :            grunt.file.readJSON('grunt/imagemin.json')
  multiresize:          grunt.file.readJSON('grunt/multiresize.json')
  browserDependencies:  grunt.file.readJSON('grunt/browserDependencies.json')

  #other
  extension_manifest :  grunt.file.readJSON('grunt/extension_manifest.json')
  notify_hooks:         grunt.file.readJSON('grunt/notify_hooks.json')
  compress :            grunt.file.readJSON('grunt/compress.json')

  }

  #register tasks
  grunt.registerTask 'test', [
    'coffeelint'
  ]

  grunt.registerTask 'build', [
#    'clean'
#    'browserDependencies'
    'extension_manifest'
    'rsync'
    'multiresize'
    'less'
    'coffee'
    'uglify'
    'imagemin'
    'compress'
  ]

  #default task
  grunt.registerTask 'default', [
    'build'
  ]

  grunt.task.run('notify_hooks')
