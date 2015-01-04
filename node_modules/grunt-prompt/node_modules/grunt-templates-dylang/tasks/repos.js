'use strict';

module.exports = function gruntTask(grunt) {

  var path = require('path');
  var pkg = require(process.cwd() + '/package.json');
  var repoData;
  grunt.registerTask('repos', function(){
    var done = this.async();

    require('anthology')
      .forUser('dylang', ['*', '!' + pkg.name, '!jobvite', '!flowdock-refined', '!logging', '!opower-jobs', '!tramp', '!lean', '!*dylang*'])
      .then(function(data){
        grunt.config('repoData', data);
          grunt.file.write(path.join(__dirname, '../data/repos.json'), JSON.stringify({repos: data }, null, 2));
        done();
      })
      .catch(function(err){
        console.log('uncaught error', err, err.stack);
      });
  });

};