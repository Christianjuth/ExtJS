popup = {

}

#setup AMD support
if typeof window.define is 'function' && window.define.amd
  window.define ['ext'], ->
    if !popup._info.min? or popup._info.min >= window.ext.version
      window.ext.popup = popup
