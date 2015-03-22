define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "queryString",
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Parse, queryString, Err) ->

  View = Backbone.View.extend({

    el: $('.page')

    initialize: (options)->
      self = this
      self.options = options
#      self.query = queryString.parse(options.query)
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      $el = self.$el

      if window.location.search
        urlParams = {}
        do ->
          pair = '' #Really a match. Index 0 is the full match; 1 & 2 are the key & val.
          tokenize = /([^&=]+)=?([^&]*)/g
          #decodeURIComponents escapes everything but will leave +s that should be ' '
          re_space = (s)->
            return decodeURIComponent(s.replace(/\+/g, " "))
          #Substring to cut off the leading '?'
          querystring = window.location.search.substring(1)
          while (pair = tokenize.exec(querystring))
             urlParams[re_space(pair[1])] = re_space(pair[2])

        base = 'https://www.parse.com'
        link = ''
        query = ''
        for param,val of  urlParams
          console.log param
          if param is 'link'
            link = urlParams['link']
          else
            if query isnt ''
              query += "&"
            query += param + '=' + encodeURIComponent(urlParams[param])

        #Ensure there's a leading slash to avoid open redirect
        if link.charAt(0) isnt "/"
          link = "/" + link

        console.log(urlParams)
        $iframe = $('<iframe>')
        $iframe.attr('src', base + link + '?' + query)
        $iframe.attr('class', 'chromeless scrollable')
        $iframe.css({height: 500})
        $iframe.appendTo($el)

      #Otherwise, this page is likely being viewed by the app owner. Explain how to use it.
      else
        compiledTemplate = Mustache.render( Err , {})
        $el.html(compiledTemplate)


      self.show()

  })

  #Our module now returns our view
  return View
