define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/account/my-plugins.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
  var PluginCollection, PluginModle, View;
  PluginModle = Parse.Object.extend("Plugin", {
    defaults: {
      name: '',
      readme: '',
      unminified: '',
      minified: ''
    }
  });
  PluginCollection = Parse.Collection.extend({});
  View = Backbone.View.extend({
    el: $('.content'),
    events: {
      'click .newPlugin': 'newPlugin'
    },
    initialize: function(options) {
      var self, user, username;
      self = this;
      self.options = options;
      _.bindAll(this, 'render');
      user = Parse.User.current();
      username = user.getUsername();
      self.plugin = new PluginCollection;
      self.plugin.query = new Parse.Query(PluginModle);
      self.plugin.query.equalTo("user", user);
      self.plugin.query.ascending("search");
      return self.plugin.fetch({
        success: function() {
          self.render(name);
          return $('.loader').fadeOut(100);
        }
      });
    },
    render: function() {
      var $el, compiledTemplate, self;
      self = this;
      $el = this.$el;
      compiledTemplate = Mustache.render($(Template).find('.view').html(), {});
      self.$el.html(compiledTemplate);
      return self.plugin.each(function(plug) {
        return self.renderPlugin(plug);
      });
    },
    renderPlugin: function(plug) {
      var $el, $this, plugName, plugReadme, plugTemplage, self, user, username;
      self = this;
      $el = this.$el;
      user = Parse.User.current();
      username = user.getUsername();
      plugName = plug.get("name");
      plugReadme = plug.get("readme");
      plugTemplage = Mustache.render($(Template).find('.item').html(), {
        name: plugName
      });
      $this = $(plugTemplage).appendTo($el.find('.plugins'));
      return $this.click(function() {
        var $modal;
        $modal = $el.find(".edit-plugin");
        $modal.find('.name').val(plugName);
        $modal.find('.readme').val(plugReadme);
        $modal.modal('show');
        $modal.find('form').unbind().submit(function(e) {
          e.preventDefault();
          return $modal.find('.save').click();
        });
        $modal.find('.save').unbind().click(function(e) {
          var file, fileName, fileUploadControl, parseFile;
          e.preventDefault();
          $modal.modal('hide');
          plugName = $modal.find(".name").val();
          plugReadme = $modal.find(".readme").val();
          $this.find('a').text(plugName);
          fileUploadControl = $modal.find(".file")[0];
          if (fileUploadControl.files.length > 0) {
            file = fileUploadControl.files[0];
            fileName = "plugin.js";
            parseFile = new Parse.File(fileName, file);
            parseFile.save();
          }
          plug.set("name", plugName);
          plug.set("readme", plugReadme);
          plug.set("file", parseFile);
          return plug.save({
            success: function() {
              return swal("Updated!", "", "success");
            },
            error: function(user, error) {
              return swal("Error!", error.message, "error");
            }
          });
        });
        return $modal.find('.delete').unbind().click(function(e) {
          e.preventDefault();
          $modal.modal('hide');
          return swal({
            title: "Are you sure?",
            text: "This action can not be undone!",
            type: "warning",
            showCancelButton: true,
            confirmButtonClass: "btn-danger",
            confirmButtonText: "Yes, delete it!"
          }, function() {
            plug.destroy();
            return $this.remove();
          });
        });
      });
    },
    newPlugin: function(e) {
      var $el, $modal, plugin, self;
      self = this;
      $el = this.$el;
      plugin = new PluginModle({});
      $modal = $el.find(".new-plugin");
      $modal.find('.name').val('');
      $modal.find('.readme').val('');
      $modal.modal('show');
      $modal.find('form').unbind().submit(function(e) {
        e.preventDefault();
        return $modal.find('.save').click();
      });
      return $modal.find('.save').unbind().click(function(e) {
        var pluginACL;
        $modal.modal('hide');
        pluginACL = new Parse.ACL(Parse.User.current());
        pluginACL.setPublicReadAccess(true);
        plugin.setACL(pluginACL);
        plugin.set('name', $modal.find('.name').val());
        plugin.set('readme', $modal.find('.readme').val());
        return plugin.save(null, {
          success: function(plug) {
            return self.renderPlugin(plug);
          },
          error: function(user, error) {
            swal("Error!", error.message, "error");
            return swal({
              title: "Error!",
              text: error.message,
              type: "error",
              showCancelButton: false,
              confirmButtonClass: "btn-primary",
              confirmButtonText: "Ok",
              closeOnConfirm: true
            }, function() {
              return $modal.modal('show');
            });
          }
        });
      });
    },
    remove: function() {
      this.$el.empty();
      this.stopListening();
      this.undelegateEvents();
      return this;
    }
  });
  return View;
});
