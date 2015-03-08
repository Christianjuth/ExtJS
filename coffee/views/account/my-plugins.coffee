define [
  "jquery",
  "underscore",
  "mustache",
  "backbone",
  "parse",
  "sweetalert",
  "text!templates/account/my-plugins.html"
], ($, _, Mustache, Backbone, Parse, swal, Template) ->

  PluginModle = Parse.Object.extend "Plugin", {
    defaults:
      name: ''
      readme: ''
  }
  PluginCollection = Parse.Collection.extend {}

  View = Backbone.View.extend({

  #vars
  unsaved: false

  #page container element
  el: $('.content')


  #backbone page events
  events :
    'click .newPlugin' : 'newPlugin'


  initialize: (options)->
    self = this
    self.options = options
    _.bindAll(this, 'render')

    user = Parse.User.current()
    username = user.getUsername()

    self.plugin = new PluginCollection
    self.plugin.query = new Parse.Query(PluginModle)
    self.plugin.query.equalTo("user", user)
    self.plugin.query.ascending("search");
    self.plugin.fetch {
      success: ->
        self.render(name)
        $('.loader').fadeOut(100)
    }

    window.onbeforeunload = ->
      if self.unsaved
        return "You have unsaved changes on this page. Do you want to leave this page and discard your changes or stay on this page?";



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



  renderPlugin : (plug) ->
    #vars
    self = this
    $el = this.$el
    user = Parse.User.current()
    username = user.getUsername()
    plugName = plug.get("name")
    plugReadme = plug.get("readme")
    search = plug.get("search")

    #render table row
    plugTemplage = Mustache.render( $(Template).find('.item').html() , {
      name: plugName
    })
    $this = $(plugTemplage).appendTo($el.find('.plugins'))

    #edit readme popup
    $this.click  (e)->
      e.preventDefault()
      self.unsaved = true
      Backbone.history.navigate 'account/my-plugins/'+search, {replace: true}

      #vars
      $modal = $el.find(".edit-plugin")
      $modal.find('.name').val(plugName)
      $modal.find('.readme').val(plugReadme)

      #render
      $modal.modal('show')

      #EVENTS
      #submit
      $modal.find('.cancel').unbind().click (e)->
        self.unsaved = false
        $modal.modal('hide')
        Backbone.history.navigate 'account/my-plugins', {replace: true}

      $modal.find('form').unbind().submit (e)->
        e.preventDefault()
        $modal.find('.save').click()

      $modal.find('.save').unbind().click (e)->
        e.preventDefault()
        self.unsaved = false
        $modal.modal('hide')
        Backbone.history.navigate 'account/my-plugins', {replace: true}

        plugName = $modal.find(".name").val()
        plugReadme = $modal.find(".readme").val()

        $this.find('a').text(plugName)

        fileUploadControl = $modal.find(".file")[0]
        if fileUploadControl.files.length > 0
          file = fileUploadControl.files[0]
          fileName = "plugin.js"
          parseFile = new Parse.File(fileName, file)
          parseFile.save()

        plug.set("name", plugName )
        plug.set("readme", plugReadme)
        plug.set("file", parseFile)
        plug.save {
          success: ->
            swal("Updated!", "", "success")
          error: (user, error) ->
            swal("Error!", error.message, "error")
        }
      #delete
      $modal.find('.delete').unbind().click (e)->
        e.preventDefault()
        $modal.modal('hide')
        swal {
          title: "Are you sure?",
          text: "This action can not be undone!",
          type: "warning",
          showCancelButton: true,
          confirmButtonClass: "btn-danger",
          confirmButtonText: "Yes, delete it!"
        }, (isConfirm) ->
          self.unsaved = false
          if isConfirm
            plug.destroy()
            $this.remove()
            Backbone.history.navigate 'account/my-plugins', {replace: true}
          else
            $modal.modal('show')

    if self.options.plugin isnt null and search is self.options.plugin.toLowerCase()
      $this.click()



  #create new plugin
  newPlugin : (e) ->
    #vars
    self = this
    $el = this.$el
    plugin = new PluginModle({})

    $modal = $el.find(".new-plugin")
    $modal.find('.name').val('')
    $modal.find('.readme').val('')

    #render
    self.unsaved = true
    $modal.modal('show')

    #EVENTS
    $modal.find('.cancel').unbind().click (e)->
        self.unsaved = false
        $modal.modal('hide')

    $modal.find('form').unbind().submit (e)->
      e.preventDefault()
      $modal.find('.save').click()

    $modal.find('.save').unbind().click (e)->
      $modal.modal('hide')

      #encrypt
      pluginACL = new Parse.ACL(Parse.User.current());
      pluginACL.setPublicReadAccess(true);
      plugin.setACL(pluginACL);

      plugin.set('name', $modal.find('.name').val())
      plugin.set('readme', $modal.find('.readme').val())
      plugin.save null, {
        success: (plug) ->
          self.unsaved = false
          self.renderPlugin(plug)
        error: (user, error) ->
          swal("Error!", error.message, "error")
          swal({
            title: "Error!"
            text: error.message
            type: "error"
            showCancelButton: false,
            confirmButtonClass: "btn-primary",
            confirmButtonText: "Ok",
            closeOnConfirm: true
          }
          , ->
            $modal.modal('show')
          )
      }



  remove: () ->
    this.$el.empty()
    this.stopListening();
    this.undelegateEvents();
    return this;

  })


  #Our module now returns our view
  return View
