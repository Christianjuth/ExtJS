'use strict';

// only needed until grunt-readme doesn't require it's own grunt
var grunt = require('grunt');
grunt.template.addDelimiters('readme', '{%', '%}');

//comma-it

module.exports = function(grunt) {

    var path = require('path');

    function image(title, imageUrl, linkUrl) {
        return (linkUrl ? '[' : '') +
          '![' + title + '](' + imageUrl  +' "' + title + '")' +
          (linkUrl ? '](' + linkUrl + ')' : '');
    }

    var config = {
        options: {
            readme: path.join(__dirname, '../includes/readme/README.md'),
            docs: 'templates',
            templates: 'node_modules/grunt-templates-dylang',
            alt: {
                src: [path.join(__dirname, '../includes/readme/README')],
                dest: './'
            },
            metadata: [
                path.join(__dirname, '../data/repos.json'),
                {
                    number: require('humanize-number')
                },
                {
                    image: image
                },
                {
                    screenshot: function(caption, url) {
                        return '' +
                        '| ' + image(caption, url) + ' |\n' +
                        '|:-------------:|\n' +
                        '| ' + caption + ' |';
                    }
                }
            ]
        }
    };

    grunt.config('readme', config);

    require('grunt-readme/tasks/readme')(grunt);
};
