/*
 * node-name
 * https://github.com/helpers/node-name
 * Copyright (c) 2013 Jon Schlinkert
 * Licensed under the MIT license.
 */

// Node dependencies.
var path = require('path');


// Export this module.
var name = module.exports = exports = {}


/**
 * Directory path, excluding the filename
 * @param  {[type]} path [description]
 * @return {[type]}      [description]
 */
name.dir = function(str) {
  return str.split(path.sep).pop().split('.')[0];
};


/**
 * Get the name of the first dir in path
 * @param  {[type]} str [description]
 * @return {[type]}     [description]
 */
name.first = function(str) {
  return str.split(path.sep).slice(0, 1)[0];
};


/**
 * Filename
 * @param  {[type]} name [description]
 * @return {[type]}      [description]
 */
name.file = function(name) {
  return path.basename(name).replace(/\.[^\.]+$/, '');
};



/**
 * Filename
 * @param  {[type]} filepath [description]
 * @return {[type]}          [description]
 */
name.filename = function(filepath) {
  return filepath.split(path.sep).pop().split('/').pop();
};


/**
 * Fullname
 * @param  {[type]} filepath [description]
 * @return {[type]}          [description]
 */
name.fullname = function(filepath) {
  return filepath.replace(/^.*[\\\/]/, '');
};


/**
 * Returns the basename of a file by removing
 * the last segment of the name
 * @param  {[type]} base [description]
 * @param  {[type]} ext  [description]
 * @return {[type]}      [description]
 *   foo/bar.baz.quux => bar.baz
 */
name.basename = function(filepath) {
  return path.basename(filepath, path.extname(filepath));
};



/**
 * Returns the basename of a file
 * @param  {[type]} filepath [description]
 * @return {[type]}          [description]
 * @example
 *   foo/bar.baz.quux => bar
 */
name.base = function(filepath) {
  var base = filepath.split(path.sep).slice(-1)[0];
  base = path.basename(filepath, path.extname(filepath));
  if (base.lastIndexOf('.') > 0) {
    base = base.substr(0, base.lastIndexOf('.'));
  }
  return base;
};


/**
 * File extension
 * @param  {[type]} str [description]
 * @return {[type]}     [description]
 */
name.ext = function(str) {
  var extname = path.extname(str);
  if (extname) {
    str = extname;
  }
  if (str[0] === ".") {
    str = str.substring(1);
  }
  return str;
};



/**
 * Returns the basename of a file, with dots and
 * underscores transformed to dashes.
 * @param  {[type]} filepath [description]
 * @return {[type]}          [description]
 */
name.dashify = function(filepath) {
  var base = filepath.split(path.sep).slice(-1)[0];
  base = path.basename(filepath, path.extname(filepath));
  if (base.lastIndexOf('.') > 0) {
    base = base.substr(0, base.lastIndexOf('.'));
  }
  return base.replace(/\-|\_|\./g, '-');
};


//    this/is/a/filepath/and-extensions.one.two.three/four/five/six.ext
// => this/is/a/filepath/and-extensions.one.two.three/four/five/six
name.removeLast = function (name) {
  return path.basename(name).replace(/\.[^\.]+$/, '');
};

//    this/is/a/filepath/and-extensions.one.two.three/four/five/six.ext
// => this/is/a/filepath/and-extensions.two.three/four/five/six.ext
name.removeFirst = function (name) {
  return path.basename(name).replace(/\.[^\.]+/, '');
};

//    this/is/a/filepath/and-extensions.one.two.three/four/five/six.ext
// => this/is/a/filepath/and-extensions
name.removeAll = function (name) {
  return path.basename(name).replace(/\.[^\.]+/g, '');
};


/**
 * Return an object with a `dirname` property and a `filename` property
 * @param  {String} path [description]
 * @return {Object}      [description]
 */
name.splitPath = function(path) {
  var dirname;
  var filename;
  path.replace(/^(.*\/)?([^/]*)$/, function(_, dir, file) {
    dirname = dir;
    filename = file;
  });
  return { dirname: dirname, filename: filename };
};

