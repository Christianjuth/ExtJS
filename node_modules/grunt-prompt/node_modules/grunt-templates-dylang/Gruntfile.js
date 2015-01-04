/*
 * grunt-notify
 * https://github.com/dylang/grunt-notify
 *
 * Copyright (c) 2012 Dylan Greene
 * Licensed under the MIT license.
 */

'use strict';

module.exports = function(grunt) {

  require('time-grunt')(grunt);

  require('load-grunt-tasks')(grunt);
  grunt.loadTasks('tasks');


  grunt.initConfig({
    watch: {
      example: {
        options: {
          spawn: true
        },
        files: [
          'Gruntfile.js',
          'tasks/**/*.js',
          'test/**/*.js'
        ],
        tasks: [
          'notify:custom_options'
        ]
      },
      test: {
        options: {
          spawn: true
        },
        files: [
          'Gruntfile.js',
          'tasks/**/*.js',
          'test/**/*.js'
        ],
        tasks: [
          'jshint',
          'mochaTest'
        ]
      }
    },


    jshint: {
      options: {
        node: true
      },
      all: [
        'Gruntfile.js',
        'tasks/**/*.js'
      ]
    }

  });

  // Whenever the "test" task is run, first clean the "tmp" dir, then run this
  // plugin's task(s), then test the result.
  grunt.registerTask('test', [
    'jshint'
  ]);

  // By default, lint and run all tests.
  grunt.registerTask('default', [
      'test'
    //'repos',
    //'readme'
  ]);

};
