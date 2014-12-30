window.ext.notification = {

    alias : "noti"

    _load : ->
      alert "notification"

    basic : (title,content,icon) ->
      if ext.browser is "chrome"
        chrome.notifications.create "", {
          iconUrl : icon
          type: "basic"
          title:title
          message: content
        }, () ->

      if ext.browser is "safari"
        new Notification(title,{body : content})

}
