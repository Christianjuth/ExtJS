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
 */
(function(){var a,b,c,d,e;d={_:{authors:["Christian Juth"],name:"UUID",aliases:["UUID"],version:"0.1.0",compatibility:{chrome:"full",safari:"full"},onload:function(a){var b,c,d,e;if(null==localStorage.uuid){for(d=[],b="0123456789abcdef",c=0;36>=c;)c++,d[c]=b.substr(Math.floor(16*Math.random()),1);return d[14]="4",d[19]=b.substr(3&d[19]|8,1),d[9]=d[14]=d[19]=d[23]="-",e=d.join(""),a.silent!==!0&&console.info('UUID "'+e+'" was created'),localStorage.uuid=e}}},reset:function(){var a,b,c,d,e;for(c=window.ext._config,d=[],a="0123456789abcdef",b=0;36>=b;)b++,d[b]=a.substr(Math.floor(16*Math.random()),1);return d[14]="4",d[19]=a.substr(3&d[19]|8,1),d[9]=d[14]=d[19]=d[23]="-",e=d.join(""),c.silent!==!0&&console.info('UUID was reset to "'+e+'"'),localStorage.uuid=e},get:function(){return localStorage.uuid}},a="",c=d._.name,b=c.toLowerCase().replace(/\ /g,"_"),e={error:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.error(a)}()},warm:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.warn(a)}()},info:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.info(a)}()}},"function"==typeof window.define&&window.define.amd&&window.define(["ext"],function(e){var f;return a=e._.browser,null==d._.min||d._.min<=window.ext.version?e._.load(b,d):(f=d._.min,console.error("Ext plugin ("+c+") requires ExtJS v"+f+"+"))})}).call(this);