define [
  "jquery",
  "underscore",
  "mustache"
  "backbone",
  "github",
  "text!templates/github/issue.html"
], ($, _, Mustache, Backbone, Github, Template) ->

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

        compiledTemplate = Mustache.render( Template, {
          issues: issues
        })
        $el.html( compiledTemplate )

        #hide loader after video loads
        $el.ready -> self.show()

  })

  #Our module now returns our view
  return View
