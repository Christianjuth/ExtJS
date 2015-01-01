'use strict';

var grunt = require('grunt'),
    gm = require('gm'),
    async = require('async');

/*
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
*/

exports.multiresize = {
  setUp: function(done) {
    done();
  },
  resize: function(test) {
    test.expect(5);

    var expected = ['tmp/Icon-72.png', 'tmp/Icon-72@2x.png'];

    async.map(expected, function(file, callback) {
      gm(file).size(callback);
    }, function(err, dimensions){
      test.ok(!err, 'there was an error getting file sizes');
      test.equal(dimensions[0].width, 72);
      test.equal(dimensions[0].height, 72);
      test.equal(dimensions[1].width, 114);
      test.equal(dimensions[1].height, 114);
      test.done();
    });

  },
  retina: function (test) {
    test.expect(3);
    var expected = ['tmp/Image.png'];

    async.map(expected, function(file, callback){
      gm(file).size(callback);
    }, function(err, dimensions){
      test.ok(!err, 'there was an error getting file');
      test.equal(dimensions[0].width, 256);
      test.equal(dimensions[0].height, 256);
      test.done();
    });
  }
};
