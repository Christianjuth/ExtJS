/*
 * assemble-yaml
 * https://github.com/assemble/assemble-yaml
 *
 * Copyright (c) 2013 Brian Woodward, contributors.
 * Licensed under the MIT license.
 */

'use strict';


// Node.js
var path  = require('path');
var fs    = require('fs');

// node_modules
var iconv = require('iconv-lite');
var chalk = require('chalk');
var glob  = require('globule');
var yaml  = require('js-yaml');
var YAML  = require('to').format.yaml;
var _     = require('lodash');
var sortObject = require('sort-object');

// Local utils.
var file = require('./utils/file');


var yamlOptions = ['filename', 'strict', 'schema'];


var fencedYAML = function(metadata, content) {
  return  '---\n' + metadata + '\n---\n' + content;
}


/**
 * Extract YAML front matter and content from files.
 * @param  {String} src  The file to read.
 * @param  {Object} opts Options to pass to js-yaml
 * @return {Object}      Object with three properties
 *  {
 *    "context": {}         // Object. Stringified JSON from YAML front matter
 *    "content": ""         // String. File content, stripped of YAML front matter
 *    "originalContent": "" // String. Both content and YAML front matter.
 *  }
 */
exports.extract = function (src, opts) {

  var options = _.extend({}, {fromFile: true}, opts);
  var data = {
    originalContent: '',
    content: '',
    context: {}
  };

  // Default delimiter
  var delim = '---';

  if (options.fromFile) {
    if (!fs.existsSync(src)) {
      console.log('File: ' + src + ' not found.');
      return false;
    }

    // Read in file
    data.originalContent = fs.readFileSync(src, 'utf8');
  } else {
    data.originalContent = src;
  }

  // Extract YAML front matter
  if (data.originalContent.indexOf(delim) !== 0) {
    data.content = data.originalContent;
    return data;
  }

  // Identify end of YAML front matter
  var eoy = data.originalContent.indexOf(delim, delim.length);

  var yamlText = '';
  if (eoy === -1) {
    yamlText = data.originalContent;
  } else {
    yamlText = data.originalContent.substring(0, eoy);
  }

  try {
    data.context = _.extend(data.context, yaml.load(yamlText, _.pick(options, yamlOptions)));
  } catch (e) {
    console.log(e);
    return false;
  }

  data.content = data.originalContent.substring(eoy + delim.length);
  return data;
};


/**
 * Add and/or extend YFM with given properties or patterns.
 * @param  {[type]} dest    [description]
 * @param  {[type]} src     [description]
 * @param  {[type]} options [description]
 * @return {[type]}         [description]
 */
exports.extend = function(src, options) {
  options = options || {};
  options.props = options.props || {};

  var content = exports.extract(src, options).content;
  var context = exports.extract(src, options).context;
  context = _.extend(context, options.props);

  // Optionally sort keys
  if(options.sort === true) {
    context = YAML.stringify(sortObject(context));
  } else {
    context = YAML.stringify(context);
  }
  return fencedYAML(context, content);
};


/**
 * Convenience method for extracting YAML front matter only.
 */
exports.extractJSON = function(src, opts) {
  return exports.extract(src, opts).context;
};
exports.readYFM = exports.extractJSON;


/**
 * Convenience method for returning the content of the file,
 * with YFM stipped.
 */
exports.stripYFM = function(src, opts) {
  return exports.extract(src, opts).content;
};
exports.strip = function(src, opts) {
  return exports.extract(src, opts).content;
};
