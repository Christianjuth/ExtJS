/*
 * assemble-yaml
 * https://github.com/assemble/assemble-yaml
 *
 * Copyright (c) 2013 Brian Woodward, contributors.
 * Licensed under the MIT license.
 */


/*global module:false*/
module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
    // Task configuration.
    jshint: {
      options: {jshintrc: '.jshintrc'},
      gruntfile: {
        src: 'Gruntfile.js'
      },
      lib_test: {
        src: ['lib/*.js', 'test/*.js']
      }
    },

    // Run mocha tests.
    mochaTest: {
      files: ['test/test.js']
    },
    mochaTestConfig: {
      options: {
        reporter: 'nyan'
      }
    }
  });

  // These plugins provide necessary tasks.
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-mocha-test');
  grunt.loadNpmTasks('grunt-readme');

  grunt.registerTask('test', ['mochaTest']);

  // Default task.
  grunt.registerTask('default', ['jshint', 'test', 'readme']);
};
