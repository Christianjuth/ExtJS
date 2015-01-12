module.exports = (grunt) ->

  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {

    pkg: grunt.file.readJSON('package.json')

    coffeelint :
      framework : [
        'coffee/framework/**/*.coffee',
        '!coffee/framework/header.coffee',
        '!coffee/framework/footer.coffee',
      ]

    #combine coffeescript files
    coffee :
      options :
        join: true
        joinExt : '.coffee'
        sourceMap : true
      framework :
        files :
          'dist/ext.js' : [
            'coffee/framework/options.coffee',
            'coffee/framework/header.coffee',
            'coffee/framework/vars.coffee',
            'coffee/framework/functions/*.coffee',
            'coffee/framework/footer.coffee',
            'coffee/framework/global.coffee',
            'coffee/framework/define.coffee',
          ]

    #minify js files
    uglify :
      options :
        preserveComments : 'some'
      framework :
        files :
          'dist/ext.min.js' : 'dist/ext.js'

    copy :
      framework :
        files : [{
          expand: true,
          cwd: 'dist/',
          src: '**',
          dest: 'test/js/',
          flatten: true,
          filter: 'isFile'
        }]

  }

  grunt.registerTask 'default', [
    'coffeelint:framework'
    'coffee:framework'
    'uglify:framework',
    'copy:framework'
  ]

  grunt.task.run('notify_hooks')
