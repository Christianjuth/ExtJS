module.exports = (grunt) ->
  #require it at the top and pass in the grunt instance
  require('time-grunt')(grunt)
  require('load-grunt-tasks')(grunt)

  #Project functions
  grunt.initConfig {
    markdown :
      options :
        template: 'markdown.jst'
      all :
        files: [
          {
            expand: true,
            cwd: 'md-templates/'
            src: '**/*.md',
            dest: 'templates/<%= srcDir %>/',
            ext: '.html'
          }
        ]

    coffee :
      options :
        bare: true
      default :
        expand: true,
        cwd: 'coffee',
        src: ['**/*.coffee'],
        dest: 'assets/js/<%= srcDir %>/',
        ext: '.js'

    less :
      options :
        compress : true
      default :
        expand: true,
        cwd: 'less',
        src: ['**/*.less'],
        dest: 'assets/css/<%= srcDir %>/',
        ext: '.css'
  }

  grunt.registerTask 'default', [
    'markdown',
    'coffee',
    'less'
  ]
