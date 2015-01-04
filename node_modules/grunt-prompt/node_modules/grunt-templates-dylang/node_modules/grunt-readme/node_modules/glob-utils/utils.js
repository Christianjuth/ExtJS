/**!
 * glob-utils
 * http://github.com/helpers/glob-utils
 *
 * Copyright (c) 2013, Jon Schlinkert, contributors
 * Licensed under the MIT license.
 */

'use strict';

// node_modules
var path = require('path');
var grunt = require('grunt');
var _ = grunt.util._;

// Export the utils module.
exports = module.exports = {};


/**
 * Globbing Utils
 */

exports.content = function (patterns, sep) {
  sep = sep || '';
  return grunt.file.expand({filter: 'isFile'}, patterns).map(function (filepath) {
      return grunt.file.read(filepath) + sep;
  }).join(grunt.util.normalizelf(grunt.util.linefeed));
};

exports.filepath = function (patterns, sep) {
  sep = sep || '';
  return grunt.file.expand(patterns).map(function (filepath) {
      return filepath + sep;
  }).join(grunt.util.normalizelf(grunt.util.linefeed));
};

exports.filename = function (patterns, sep) {
  sep = sep || '';
  return grunt.file.expand({filter: 'isFile'}, patterns).map(function (filepath) {
      return path.basename(filepath) + sep;
  }).join(grunt.util.normalizelf(grunt.util.linefeed));
};

exports.basename = function (patterns, sep) {
  sep = sep || '';
  return grunt.file.expand({filter: 'isFile'}, patterns).map(function (filepath) {
      return path.basename(filepath, path.extname(filepath)) + sep;
  }).join(grunt.util.normalizelf(grunt.util.linefeed));
};

