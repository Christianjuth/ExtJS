#define.coffee

#Define a global copy of the library.
#This is important because this is where
#ExtJS becomes accessible to the user in
#the window object
window.ext = ext

#This function defines the "ext" AMD module.
#Without this ExtJS would not be compatible
#with things like requirejs.
if typeof window.define is 'function' && window.define.amd
  window.define 'ext', ['jquery'], ->
    ext._onload()
    window.ext
