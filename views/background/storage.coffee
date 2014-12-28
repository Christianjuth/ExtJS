
storage =
  ini : () ->
    $.ajax({
    url: "../../configure.json",
    dataType: 'json',
    async: false,
    success: (data) ->
      if framework.browser is "chrome"
        options = data.options
        storedOptions = $.parseJSON localStorage.options
        for option in options
          if typeof storedOptions[option.key] is "undefined"
            framework.settings.set option.key,option.default

      storage = data.storage
      for item in storage
        if typeof localStorage[item.key] is "undefined"
          localStorage[item.key] = item.default
    })

define () ->
  return storage

#define global storage variable
if typeof window is "object" and typeof window.document is "object"
  window.storage = storage
