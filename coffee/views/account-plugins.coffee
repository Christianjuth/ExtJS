define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "sweetalert",
  "text!templates/account-plugins.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  PluginModle = Parse.Object.extend "Plugin", {
    defaults:
      name: ''
      readme: ''
      unminified: ''
      minified: ''
  }
  PluginCollection = Parse.Collection.extend {}

  View = Backbone.View.extend({

  #page container element
  el: $('.content')


  #backbone page events
  events :
    'click .newPlugin' : 'newPlugin'


  initialize: () ->
    self = this
    user = Parse.User.current()
    username = user.getUsername()
    _.bindAll(this, 'render')

    self.plugin = new PluginCollection
    self.plugin.query = new Parse.Query(PluginModle)
    self.plugin.query.equalTo("user", user)
    self.plugin.fetch {
      success: -> self.render(name)
    }



  #render page
  render: ->
    #vars
    self = this
    $el = this.$el

    compiledTemplate = Mustache.render( $(Template).find('.view').html() , {})
    #Append our compiled template to this Views "el"
    self.$el.html( compiledTemplate )

    #get users plugins
    self.plugin.each (plug)->
      self.renderPlugin(plug)

    #reset UI
    if window.innerWidth < 850
      $(".sidebar .links").slideUp()
      $(".sidebar").attr "toggle","false"

    $('.loader').fadeOut(100)



  renderPlugin : (plug) ->
    #vars
    self = this
    $el = this.$el
    user = Parse.User.current()
    username = user.getUsername()

    plugTemplage = Mustache.render( $(Template).find('.item').html() , {
      name: plug.get("name")
      unmin: plug.get("unminified")
      min: plug.get("minified")
      readme: plug.get("readme")
    })
    $this = $(plugTemplage).appendTo(self.$el.find('.plugins'))

    #form submit function update plugin
    $this.submit (e) ->
      e.preventDefault()

      name = $this.find(".name").val()
      readme = $this.find(".readme").val()
      unmin = $this.find(".unminified-link").val()
      min = $this.find(".minified-link").val()

      plug.set("developer", username)
      plug.set("name", name )
      plug.set("readme", readme)
      plug.set("unminified", unmin)
      plug.set("minified", min)
      plug.save {
        success: ->
          swal("Updated!", "", "success")
        error: (user, error) ->
          swal("Error!", error.message, "error")
      }

    #delete function
    $this.find(".delete").click (e) ->
      e.preventDefault()
      swal {
        title: "Are you sure?",
        text: "This action can not be undone!",
        type: "warning",
        showCancelButton: true,
        confirmButtonClass: "btn-danger",
        confirmButtonText: "Yes, delete it!"
      }, () ->
        plug.destroy()
        $this.fadeOut ->
          $this.remove()



  #create new plugin
  newPlugin : (e) ->
    #vars
    self = this
    user = Parse.User.current()
    username = Parse.User.current().getUsername()

    plugin = new PluginModle({
      user: user
      developer: username
    })

    #encrypt
    pluginACL = new Parse.ACL(Parse.User.current());
    pluginACL.setPublicReadAccess(true);
    plugin.setACL(pluginACL);

    plugin.save null, {
      success: (plug) ->
        self.renderPlugin(plug)
      error: (user, error) ->
        swal("Error!", error.message, "error")
    }


  remove: () ->
    this.$el.empty()
    this.stopListening();
    this.undelegateEvents();
    return this;

  })


  #Our module now returns our view
  return View
