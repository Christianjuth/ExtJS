# node-name

> Basic utility methods for transforming and handling file paths. As with node.js, the file system is not consulted to check whether paths are valid.

## Getting Started
Install the module with: `npm install node-name`

Require it:

```js
var name = require('node-name');
```

Test it:

```js
console.log(name.basename('foo/bar/baz.quux'));
// => baz
```

## Methods

```js
name.dir('path/to/transform.txt');
name.file('path/to/transform.txt');
name.filename('path/to/transform.txt');
name.base('path/to/transform.txt');
name.basename('path/to/transform.txt');
name.ext('path/to/transform.txt');
```

## About

After I started paying attention to how the Node.js [path module](http://nodejs.org/api/path.html) handles and transforms file paths (`path.basename`, `path.extname`, etc.), I was surprised at the results. Not that I should have been, but when utilities like this are so easy to use, I sometimes forget that I still need to look at what's happening under the hood.

Currently, this module just makes it a tiny bit more convenient to see how paths are transformed by these utilities. But over time my goal is to build out this library to include more robust utilities.

Contributions and feedback are welcome!


## Author

+ [github.com/jonschlinkert](https://github.com/jonschlinkert)
+ [twitter.com/jonschlinkert](http://twitter.com/jonschlinkert)


## License
Copyright (c) 2013 Jon Schlinkert
Licensed under the [MIT License (MIT)](LICENSE-MIT)
