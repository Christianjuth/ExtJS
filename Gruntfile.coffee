module.exports = (grunt) ->

  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #set config vars
  config = grunt.file.readJSON('configure.json')
  name = config.name

  #Project functions
  grunt.initConfig {

  #package.json
  pkg:                  grunt.file.readJSON('package.json')

  #scripts
  coffeelint:           grunt.file.readJSON('grunt/coffeelint.json')
  coffee:               grunt.file.readJSON('grunt/coffee.json')
  uglify:               grunt.file.readJSON('grunt/uglify.json')

  #other
  clean:                grunt.file.readJSON('grunt/clean.json')
  copy:                 grunt.file.readJSON('grunt/copy.json')
  browserDependencies:  grunt.file.readJSON('grunt/browserDependencies.json')
  extension_manifest:   grunt.file.readJSON('grunt/extension_manifest.json')

  #post build
  notify_hooks:         grunt.file.readJSON('grunt/notify_hooks.json')

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
  grunt.registerTask 'test', [
    'coffeelint'
  ]

  grunt.registerTask 'build', [
    'clean'
    'browserDependencies'
    'extension_manifest'
    'coffee'
    'uglify'
    'copy'
  ]

  #default grunt task
  grunt.registerTask 'default', [
    'test'
    'build'
  ]

  #notify when task is done
  grunt.task.run('notify_hooks')
