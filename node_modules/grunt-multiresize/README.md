# grunt-multiresize

> Export multiple sizes from an image

## Getting Started
This plugin requires GraphicsMagick and Grunt `~0.4.1`

First download and install [GraphicsMagick](http://www.graphicsmagick.org/). In Mac OS X, you can simply use [Homebrew](http://mxcl.github.io/homebrew/) and do:

    brew install graphicsmagick

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-multiresize --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-multiresize');
```

## The "multiresize" task

### Overview
In your project's Gruntfile, add a section named `multiresize` to the data object passed into `grunt.initConfig()`.

```js
grunt.initConfig({
  multiresize: {
    target: {
      src: 'path/to/source',
      dest: ['path/to/dest1', '/path/to/dest2'],
      destSizes: ['72x72', '114x114']
    }
  },
})
```

### Options

#### options.src
Type: `String`

The original file to be resized

#### options.dest
Type: `String` or `Array`

The files to be written by this script

#### options.destSizes
Type: `Array`

The image dimensions expected. The format can be `witdhxheight` or `n%`

### Usage Examples

#### Outputting all icons
This project was originally created to resize our project icons to conform to
CoronaSDK spec. This is our config file.

```js
grunt.initConfig({
  multiresize: {
    iOS: {
      src: 'orig/Icon-512.png',
      dest: ['Icon.png', 'Icon@2x.png', 'Icon-72.png', 'Icon-72@2x.png'],
      destSizes: ['57x57', '114x114', '72x72', '144x144']
    },
    Android: {
      src: 'orig/Icon-Android-512.png',
      dest: ['Icon-ldpi.png', 'Icon-mdpi.png', 'Icon-hdpi.png', 'Icon-xhdpi.png'],
      destSizes: ['36x36', '48x48', '72x72', '96x96']
    }
  },
})
```

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
v0.1.0: Initial release
