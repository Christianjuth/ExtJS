module.exports = (grunt) ->

  #Project configuration.
  grunt.initConfig {
    pkg: grunt.file.readJSON('package.json'),


    coffeelint :
      default: ['js/coffee/**/*.coffee']


    less :
      default :
        options :
          compress: true

        files: [
          {
            expand: true,
            cwd: "less",
            src: ['**/*.less'],
            dest: "assets/css/<%= srcDir %>/",
            ext: ".css"
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.less'],
            dest: "views/<%= srcDir %>/",
            ext: ".css"
          }
        ]


    coffee :
      default :
        files: [
          {
            expand: true,
            cwd: "coffee",
            src: ['**/*.coffee'],
            dest: "assets/js/<%= srcDir %>/",
            ext: ".js"
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.coffee'],
            dest: "views/<%= srcDir %>/",
            ext: ".js"
          }
        ]


    uglify :
      options :
        compress :
          global_defs:
            "DEBUG": false
          dead_code: true

      default :
        files: [
          {
            expand: true,
            cwd: 'assets/js/',
            src: '**/*.js',
            dest: 'assets/js/<%= srcDir %>/'
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.js'],
            dest: "views/<%= srcDir %>/"
          }
        ]
  }

  #load tasks
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-newer');

  #register tasks
  grunt.registerTask 'debug', ['coffeelint']

  #fallback
  grunt.registerTask 'default', ['newer:less:default','newer:coffee:default','newer:uglify:default']
