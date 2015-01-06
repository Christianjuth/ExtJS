popup = {

}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    window.ext.popup = popup
