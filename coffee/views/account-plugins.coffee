define [
  "jquery",
  "underscore",
  "mustache",
  "parse",
  "sweetalert",
  "text!templates/account-plugins.html"
], ($, _, Mustache, Parse, swal, PageTemplate) ->

#  user = Parse.User.current()
#  username = Parse.User.current().getUsername()
#
#  PluginModle = Parse.Object.extend "Plugin", {
#    user: user
#    developer: username
#    name: ''
#    readme: ''
#    unminified: ''
#    minified: ''
#  }
#  PluginCollection = Parse.Collection.extend {}
#
#  View = Parse.View.extend({
#
#  #page container element
#  el: $('.content')
#
#
#  #backbone page events
#  events :
#    'click .newPlugin' : 'newPlugin'
#
#
#  initialize: () ->
#    self = this
#    _.bindAll(this, 'render')
#
#    self.plugin = new PluginCollection
#    self.plugin.query = new Parse.Query(PluginModle)
#    self.plugin.query.equalTo("user", user)
#    self.plugin.fetch {
#      success: -> self.render(name)
#    }
#
#
#
#  #render page
#  render: ->
#    #vars
#    self = this
#    $el = this.$el
#
#    compiledTemplate = Mustache( $(Template).find('.view').html() , {})
#    #Append our compiled template to this Views "el"
#    self.$el.html( compiledTemplate )
#
#    #get users plugins
#
#    #reset UI
#    if window.innerWidth < 850
#      $(".sidebar .links").slideUp()
#      $(".sidebar").attr "toggle","false"
#
#
#
#  plugin : (plug) ->
#    #vars
#    $el = this.$el
#    $template = $($.parseHTML PluginTemplate)
#    $item = $template
#    $plugins = container
#    username = Parse.User.current().getUsername()
#    #set name and link inputs
#
#    #create plugin element
#    $this = $item.clone(false,false).appendTo($plugins)
#
#    $this.find(".name").val(name)
#    $this.find(".readme").val(readme)
#    $this.find(".unminified-link").val(unminified)
#    $this.find(".minified-link").val(minified)
#
#    #form submit function update plugin
#    $this.submit (e) ->
#      e.preventDefault()
#      item.set("developer", username)
#      item.set("name", String $this.find(".name").val())
#      item.set("readme", String $this.find(".readme").val())
#      item.set("unminified", String $this.find(".unminified-link").val())
#      item.set("minified", String $this.find(".minified-link").val())
#      item.save {
#        success: ->
#          swal("Updated!", "", "success")
#        error: (user, error) ->
#          $this.find(".name").val(name)
#          $this.find(".readme").val(readme)
#          $this.find(".unminified-link").val(unminified)
#          $this.find(".minified-link").val(minified)
#          swal("Error!", error.message, "error")
#      }
#
#    #delete function
#    $this.find(".delete").click (e) ->
#      e.preventDefault()
#      swal {
#        title: "Are you sure?",
#        text: "This action can not be undone!",
#        type: "warning",
#        showCancelButton: true,
#        confirmButtonClass: "btn-danger",
#        confirmButtonText: "Yes, delete it!"
#      }, () ->
#        item.destroy()
#        $this.fadeOut ->
#          $this.remove()
#
#
#
#
#
#  #create new plugin
#  newPlugin : (e) ->
#    #vars
#    user = Parse.User.current()
#    username = Parse.User.current().getUsername()
#    $el = this.$el
#    appendPlugin = this.plugin
#    #create plugin
#    $plugins = $el.find('.plugins')
#
#    Plugin = Parse.Object.extend("Plugin")
#    plugin = new Plugin()
#    pluginACL = new Parse.ACL(Parse.User.current());
#    pluginACL.setPublicReadAccess(true);
#    plugin.setACL(pluginACL);
#
#    plugin.save null, {
#      success: (item) ->
#        #vars
#        name = String item.get("name")
#        readme = String item.get("readme")
#        minified = String item.get("minified")
#        unminified = String item.get("unminified")
#        appendPlugin name, readme, minified, unminified, $plugins, item
#
#      error: (user, error) ->
#        swal("Error!", error.message, "error")
#    }
#
#
#  remove: () ->
#    this.$el.empty()
#    this.stopListening();
#    this.undelegateEvents();
#    return this;
#
#  })
#
#  #Our module now returns our view
#  return View;
