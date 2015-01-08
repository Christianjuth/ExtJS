/*
 * grunt-browser-dependencies
 * http://gruntjs.com/
 *
 * Copyright (c) 2013 Michael Benin, contributors
 * Licensed under the MIT license.
 */
var http = require('http-get');

module.exports = function (grunt) {
    "use strict";
    grunt.registerMultiTask('browserDependencies', 'Get js files and rename them', function () {

        var options = this.options({});
        var dir = this.data.dir;
        var files = this.data.files;
        var done = this.async();
        var path = dir +'/';
        var total = 0;
        grunt.file.mkdir(dir);

        files.forEach(function(file){
            var keys = Object.keys(file);
            var url = file[keys[0]];
            var file_path = path+keys[0];
            var increaseTotal = function(){
                total++;
                if(total === files.length){
                    done(true);
                }
            };

            if (!grunt.file.exists(file_path)){
                http.get({url: url}, file_path, function (error, result) {
                    if (error) {
                        grunt.log.write(error);
                        done(false);
                    } else {
                        grunt.log.write('✔ '.green + 'File downloaded at: ' + result.file + '\n');
                        increaseTotal();
                    }
                });
            }else{
                grunt.log.write('✔ '.green + 'File already exists at: ' + file_path + '\n');
                increaseTotal();
            }
        });
    });
};
