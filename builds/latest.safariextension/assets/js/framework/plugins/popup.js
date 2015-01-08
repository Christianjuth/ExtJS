/*!
The MIT License (MIT)

Copyright (c) 2014 Christian Juth

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

https://github.com/Christianjuth/
 */
(function(){var a,b,c,d;d={},c=d._info.name,a=c.toLowerCase().replace(/\ /g,"_"),b={error:function(a){return console.error("Ext plugin ("+c+") says: "+a)},warn:function(a){return console.warn("Ext plugin ("+c+") says: "+a)},info:function(a){return console.warn("Ext plugin ("+c+") says: "+a)}},"function"==typeof window.define&&window.define.amd&&window.define(["ext"],function(){return null==d._info.min||d._info.min<=window.ext.version?window.ext[a]=d:console.error("Ext plugin ("+c+") requires ExtJS v"+d._info.min+"+")})}).call(this);