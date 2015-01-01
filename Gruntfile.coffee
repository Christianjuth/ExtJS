module.exports = (grunt) ->
  config = grunt.file.readJSON("configure.json")

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
            dest: "dist/latest/assets/css/<%= srcDir %>/",
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
            dest: "dist/latest/assets/js/<%= srcDir %>/",
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
            cwd: 'dist/latest/assets/js/',
            src: '**/*.js',
            dest: 'dist/latest/assets/js/<%= srcDir %>/'
          },
          {
            expand: true,
            cwd: "views",
            src: ['**/*.js'],
            dest: "views/<%= srcDir %>/"
          }
        ]


    multiresize :
      default :
        src: 'icons/icon.png',
        dest: ['icon-128.png', 'icon-96.png','icon-64.png','icon-48.png','icon-38.png','icon-32.png'],
        destSizes: ['128x128', '96x96', '64x64', '48x48', '38x38', '32x32']

    compress :
      package :
        options :
          archive : 'dist/' + config.version + '.zip'
        src: ['**/*'],
        expand: true,
        cwd: 'dist/latest/',

    copy :
      package :
        src: ['**/*', '!**/dist/**', '!**/node_modules/**', '!Gruntfile.*', '!package.json', '!**/.git/**', '!**/coffee/**', '!**/less/**'],
        expand: true,
        cwd: '.',
        dest: 'dist/latest/'

      icons :
        src: ['**/*.jpg', '**/*.jpeg', '**/*.png'],
        expand: true,
        cwd: 'icons/menu-icons',
        dest: 'dist/latest/assets/icons'

    clean:
      latest : ["dist/latest/**/*"]
  }

  #load tasks
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-less');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-compress');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-multiresize');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');
  grunt.loadNpmTasks('grunt-newer');

  #register tasks
  grunt.registerTask 'debug', ['coffeelint']
  grunt.registerTask 'img', ['multiresize']

  #fallback
  grunt.registerTask 'default', ['newer:copy:package', 'newer:copy:icons', 'newer:less:default', 'newer:coffee:default','newer:uglify:default']

  #package
  grunt.registerTask 'package', ['clean:latest', 'copy:package', 'copy:icons', 'less:default', 'coffee:default','uglify:default']
