/*
 * grunt-multiresize
 * https://github.com/jeduan/icons-yogome
 *
 * Copyright (c) 2013 Jeduan Cornejo
 * Licensed under the MIT license.
 */

'use strict';
var gm = require('gm'),
    async = require('async');

module.exports = function(grunt) {

  // Please see the Grunt documentation for more information regarding task
  // creation: http://gruntjs.com/creating-tasks

  grunt.registerMultiTask('multiresize', 'Allows to create multiple resized images from an image', function() {
    var finishTask = this.async();
    var options = this.options({quality: 100});

    var isRetina2x = function(imagePath) {
      var i = imagePath.lastIndexOf('.');
      if (i !== -1) {
        return imagePath.substr(i - 3, 3) === '@2x';
      }
      return false;
    };

    async.each(this.files, function(f, nextFile) {
      var src, i = 0;

      //Ignores all but first src file
      if (f.src.length >= 1) {
        src = f.src[0];
      } else {
        return nextFile();
      }

      if (!grunt.file.exists(src)) {
        return nextFile(new Error('Source file "'+ src +'" not found.'));
      }

      if (isRetina2x(src)) {
        if (! f.dest) {
          f.dest = [src.replace('@2x', '')];
        }
        if (! f.destSizes) {
          f.destSizes = ['50%'];
        }
      }

      if (grunt.util.kindOf(f.dest) !== 'array') {
        f.dest = [f.dest];
      }

      if (grunt.util.kindOf(f.destSizes) !== 'array') {
        f.destSizes = [f.destSizes];
      }

      async.map(f.dest, function(dest, nextMap) {
        var folder = dest.substr(0, dest.lastIndexOf('/')),
            destSize = f.destSizes[i++];

        if (! grunt.file.exists(folder)) {
          grunt.log.ok('Creating folder "' + folder + '".');
          grunt.file.mkdir(folder);
        }

        async.waterfall([
          function(step) {
            if (/\d+x\d+/.test(destSize)) {
              var size = destSize.split('x');
              step(null, size[0], size[1]);
            } else if (/\d{1,2}%/.test(destSize)) {
              // if the destSize is is xx% then measure the file and pass the sizes
              gm(src).size(function(err, size) {
                if (err) { return step(err); }

                var factor = parseInt(destSize, 10) / 100;
                step(null, Math.floor(size.width * factor), Math.floor(size.height * factor));
              });
            }
          }, function (width, height, step) {
            gm(src)
              .resize(width, height, '^>')
              .gravity('Center')
              .quality(options.quality)
              .crop(width, height)
              .write(dest, function(err){
                if(err) { return step(err); }

                grunt.log.ok('Created "' + dest + '".');
                step(null);
              });
          }
        ], nextMap);
      }, nextFile);

    }, function(err) {
      if(err) {
        grunt.log.error(err.message);
        return finishTask(false);
      }
      finishTask();
    });

  });
};
