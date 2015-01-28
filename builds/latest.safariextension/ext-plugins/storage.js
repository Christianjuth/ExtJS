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
(function(){var a,b,c,d,e,f=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};d={_:{authors:["Christian Juth"],name:"Storage",aliases:["localStorage","local"],version:"0.1.0",min:"0.1.0",compatibility:{chrome:"full",safari:"full"},onload:function(){var a,b,c,d,f,g;for(null==localStorage.storage&&(localStorage.storage=JSON.stringify({})),a=ext._.getConfig(),f=a.storage,g=[],c=0,d=f.length;d>c;c++)b=f[c],"undefined"==typeof ext.storage.get(b.key)?(e.info('storage item "'+b.key+'" was created'),g.push(ext.storage.set(b.key,b["default"]))):g.push(void 0);return g}},set:function(a,b){var c;return c=$.parseJSON(localStorage.storage),c[a]=b,localStorage.storage=JSON.stringify(c)},get:function(a){var b;return b=$.parseJSON(localStorage.storage),b[a]},remove:function(a){var b;return b=$.parseJSON(localStorage.storage),delete b[a],localStorage.storage=JSON.stringify(b)},removeAll:function(a){var b,c,d,e;for(e=ext.storage.dump(),c=0,d=e.length;d>c;c++)b=e[c],f.call(a,b)<0&&ext.storage.remove(b);return ext.storage.dump()},dump:function(){var a;return a=[],$.each($.parseJSON(localStorage.storage),function(b){return a.push(b)}),a}},a="",c=d._.name,b=c.toLowerCase().replace(/\ /g,"_"),e={error:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.error(a)}()},warm:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.warn(a)}()},info:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.info(a)}()}},"function"==typeof window.define&&window.define.amd&&window.define(["ext"],function(e){var f;return a=e._.browser,null==d._.min||d._.min<=window.ext.version?e._.load(b,d):(f=d._.min,console.error("Ext plugin ("+c+") requires ExtJS v"+f+"+"))})}).call(this);