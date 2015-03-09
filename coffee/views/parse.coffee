define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "queryString"
], ($, _, Mustache, Backbone, Parse, queryString) ->

  View = Backbone.View.extend({

    el: $('.content')

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
        $iframe.appendTo($el)

      #Otherwise, this page is likely being viewed by the app owner. Explain how to use it.
      else
        $el.html(
          '<h1>This page lets you host Parse.com content from your own domain.</h1>' +
          '<p>Right click <a href="' + window.location.pathname + '">here</a> to save this page. ' +
          'Upload it to your own website and paste the URL in the "Parse Frame URL" ' +
          'app settings at Parse.com.</p>'
        )


      $('.loader').fadeOut(100)

  })

  #Our module now returns our view
  return View
