define [
  "jquery",
  "underscore",
  "mustache"
  "backbone",
  "github",
  "text!templates/github/issue-id.html"
  "text!templates/404.html"
], ($, _, Mustache, Backbone, Github, Template, Err) ->

  View = Backbone.View.extend({

    el: $('.page')

    initialize: (options)->
      self = this
      self.options = options
      github = new Github({
        token: "65e6e92be89fc2049eb1ba194198cbacc60f7384"
        auth: "oauth"
      })
      self.issues = github.getIssues("christianjuth", "ExtJS")
      _.bindAll(this, 'render')
      this.render()

    render: ->
      self = this
      $el = self.$el

      self.issues.list {}, (err, issues)->
        issue = _.find(issues, (item)->
          return item.number is parseInt(self.options.id)
        )

        #Using Underscore we can compile our template with data
        if issue?

          comments = $.ajax {
            dataType: "json"
            url: issue.comments_url
            async: false
          }

          compiledTemplate = Mustache.render( Template, {
            title: issue.title
            number: issue.number
            body: issue.body
            comments: comments
          })
        else
          compiledTemplate = Mustache.render( Err, {})
        $el.html( compiledTemplate )

        #hide loader after video loads
        $el.ready -> self.show()

  })

  #Our module now returns our view
  return View
