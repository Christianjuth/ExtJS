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
(function(){var a,b,c,d,e=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};d={_info:{authors:["Christian Juth"],name:"Storage",version:"0.1.0",min:"0.1.0",compatibility:{chrome:"full",safari:"full"}},_aliases:["localStorage","local"],_load:function(){return null==localStorage.storage&&(localStorage.storage=JSON.stringify({})),$.ajax({url:"../../configure.json",dataType:"json",async:!1,success:function(a){var b,c,d,e,f;for(e=a.storage,f=[],c=0,d=e.length;d>c;c++)b=e[c],f.push("undefined"==typeof ext.storage.get(b.key)?ext.storage.set(b.key,b["default"]):void 0);return f}})},set:function(a,b){var c;return c=$.parseJSON(localStorage.storage),c[a]=b,localStorage.storage=JSON.stringify(c)},get:function(a){var b;return b=$.parseJSON(localStorage.storage),b[a]},remove:function(a){var b;return b=$.parseJSON(localStorage.storage),delete b[a],localStorage.storage=JSON.stringify(b)},removeAll:function(a){var b,c,d,f;for(f=ext.storage.dump(),c=0,d=f.length;d>c;c++)b=f[c],e.call(a,b)<0&&ext.storage.remove(b);return ext.storage.dump()},dump:function(){var a;return a=[],$.each($.parseJSON(localStorage.storage),function(b){return a.push(b)}),a}},c=d._info.name,a=c.toLowerCase().replace(/\ /g,"_"),b={error:function(a){return console.error("Ext plugin ("+c+") says: "+a)},warn:function(a){return console.warn("Ext plugin ("+c+") says: "+a)},info:function(a){return console.warn("Ext plugin ("+c+") says: "+a)}},"function"==typeof window.define&&window.define.amd&&window.define(["ext"],function(){return null==d._info.min||d._info.min<=window.ext.version?window.ext[a]=d:console.error("Ext plugin ("+c+") requires ExtJS v"+d._info.min+"+")})}).call(this);