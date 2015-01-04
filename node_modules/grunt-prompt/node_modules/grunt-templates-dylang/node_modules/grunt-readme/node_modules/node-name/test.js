/*
 * node-name
 * https://github.com/helpers/node-name
 * Copyright (c) 2013 Jon Schlinkert
 * Licensed under the MIT license.
 */

// Node.js
var path = require('path');

// node_modules
var chalk = require('chalk');
var _ = require('lodash');

// This module.
var name = require('./index');


var arr = [
  '.foo.bar/baz.quux',
  '.foo.bar/baz.quux.',
  '.html',
  '/foo.bar.baz.quux',
  '/foo/bar/baz/asdf/quux',
  '/foo/bar/baz/asdf/quux.html',
  '/foo/bar/baz/quux',
  '/quux',
  '/quux/',
  'foo.bar.baz.quux',
  'foo.bar/baz.quux',
  'foo/bar.baz.quux',
  'foo/bar.baz.quux/',
  'foo/bar.baz/quux',
  'foo/bar/baz.quux',
  'foo/bar/baz.quux.',
  'foo/bar/baz/quux',
  'foo/bar/baz/quux/',
  'quux/',
];


function logger(fn, name) {
  name = name || 'name';
  console.log(name.bold + ':\n' + arr.map(function (item) {
    return ('>> ' + name + ': ').yellow + item +  ' =>\t'.green  + fn(item);
  }).join('\n') + '\n');
}

function loggerObj(fn, name) {
  name = name || 'name';
  console.log(name.bold + ':\n' + arr.map(function (item) {
    return ('>> ' + name + ': ').yellow + item +  ' =>\t\n'.green  + JSON.stringify(fn(item), null, 2);
  }).join('\n') + '\n');
}


logger(path.basename, 'basename');
logger(path.dirname,  'dirname');
logger(path.extname,  'extname');

logger(name.base,     'base');
logger(name.basename, 'basename');
logger(name.dir,      'dir');
logger(name.ext,      'ext');
logger(name.first,    'first');

logger(name.file,     'file');
logger(name.filename, 'filename');
logger(name.fullname, 'fullname');


loggerObj(name.splitPath, 'splitPath');
