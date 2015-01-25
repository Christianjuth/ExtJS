
module.exports = (grunt) ->
  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #set config vars
  config = grunt.file.readJSON('configure.json')
  name = config.name

  #Project functions
  grunt.initConfig {

  pkg: grunt.file.readJSON('package.json')

  #lint functions
  coffeelint : default: ['plugin/**/*.coffee']

  #combine coffeescript files
  coffee : grunt.file.readJSON('grunt/coffee.json')


  #minify js files
  uglify : grunt.file.readJSON('grunt/uglify.json')

  #copy files for testing
  copy : grunt.file.readJSON('grunt/copy.json')

  #notify on task finish
  notify_hooks :
    options :
      enabled : true,
      max_jshint_notifications : 5,
      title : 'ExtJS Plugin Builder',
      success : true,
      duration : 3

  #download cdn files
  browserDependencies : grunt.file.readJSON('grunt/browserDependencies.json')

  #clean old files
  clean : grunt.file.readJSON('grunt/clean.json')

  extension_manifest :
    default :
      file: 'test.safariextension/configure.json',
      dest: 'test.safariextension/'

  }

  #dynamic options
  #grunt coffee
  coffeeFiles = {}
  coffeeFiles['dist/'+name+'.js'] = ["plugin/licence.coffee", "plugin/plugin.coffee", "plugin/define.coffee"]
  grunt.config.set 'coffee.default.files', coffeeFiles
  #grunt copy
  grunt.config.set 'copy.default.rename', (dest, src) ->
    if ! /\.(map|coffee)$/.test src
      src = src.replace(name,'plugin')
    return dest + src
  #grunt uglify
  uglifyFiles = {}
  uglifyFiles['dist/'+name+'.min.js'] = 'dist/'+name+'.js'
  grunt.config.set 'uglify.default.files', uglifyFiles

  #define tasks
  grunt.registerTask 'default', [
    'coffeelint'
    'clean'
    'browserDependencies'
    'extension_manifest'
    'coffee'
    'uglify'
    'copy'
  ]

  grunt.task.run('notify_hooks')
