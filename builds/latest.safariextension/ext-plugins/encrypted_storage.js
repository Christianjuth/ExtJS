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
(function(){var a,b,c,d,e,f,g=[].indexOf||function(a){for(var b=0,c=this.length;c>b;b++)if(b in this&&this[b]===a)return b;return-1};d={_:{authors:["Christian Juth"],name:"Encrypted Storage",aliases:["enStore","enStorage"],version:"0.1.0",min:"0.1.0",compatibility:{chrome:"full",safari:"full"},github:"",onload:function(){var a,b,c,d,e,g;for(null==localStorage.encryptedStorage&&(localStorage.encryptedStorage=JSON.stringify({})),a=ext._.getConfig().encryptedStorage,c=JSON.parse(localStorage.encryptedStorage),g=[],d=0,e=a.length;e>d;d++)b=a[d],"undefined"==typeof c[b.key]?(f.info('storage item "'+b.key+'" default password is "password"'),g.push(ext.encrypted_storage.set(b.key,b["default"],"password"))):g.push(void 0);return g}},set:function(a,b,c){var d,e,f,g;if(g="key string, passwd string, value string",d=["string","string","string"],e=ext._.validateArg(arguments,d,g),null!=e)throw new Error(e);return f=$.parseJSON(localStorage.encryptedStorage),f[a]=sjcl.encrypt(b,c),localStorage.encryptedStorage=JSON.stringify(f)},get:function(a,b){var c,d,e,g,h,i;if(i="key string, passwd string",d=["string","string"],e=ext._.validateArg(arguments,d,i),g="",h=$.parseJSON(localStorage.encryptedStorage),"undefined"!=typeof h[a]){try{g=sjcl.decrypt(b,h[a])}catch(j){c=j,f.warn(c.message),g=!1}return g}},changePasswd:function(a,b,c){var d,e,f,g;return f="key string, oldPasswd string, newPasswd string",d=["string","string","string"],e=ext._.validateArg(arguments,d,f),g=ext.encrypted_storage.get(a,b),ext.encrypted_storage.set(a,g,c)},remove:function(a){var b,c,d,f;return f="key string",b=["string"],c=ext._.validateArg(arguments,b,f),d=$.parseJSON(localStorage.encryptedStorage),delete d[a],localStorage.encryptedStorage=JSON.stringify(e)},removeAll:function(a){var b,c,d,e,f,h,i;for(e="exceptions array",b=["object"],d=ext._.validateArg(arguments,b,e),i=ext.encrypted_storage.dump(),f=0,h=i.length;h>f;f++)c=i[f],g.call(a,c)<0&&ext.encrypted_storage.remove(c);return ext.encrypted_storage.dump()},dump:function(){var a;return a=[],$.each($.parseJSON(localStorage.encryptedStorage),function(b){return a.push(b)}),a}},e=[],a="",c=d._.name,b=c.toLowerCase().replace(/\ /g,"_"),f={error:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.error(a)}()},warm:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.warn(a)}()},info:function(a){return function(){return a="Ext plugin ("+c+") says: "+a,ext._.log.info(a)}()}},"function"==typeof window.define&&window.define.amd&&window.define(["ext"],function(e){var f;return a=e._.browser,null==d._.min||d._.min<=window.ext.version?e._.load(b,d):(f=d._.min,console.error("Ext plugin ("+c+") requires ExtJS v"+f+"+"))})}).call(this);