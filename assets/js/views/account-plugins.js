define(["jquery", "underscore", "mustache", "backbone", "parse", "sweetalert", "text!templates/account-plugins.html"], function($, _, Mustache, Backbone, Parse, swal, Template) {
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
    initialize: function() {
      var self, user, username;
      self = this;
      user = Parse.User.current();
      username = user.getUsername();
      _.bindAll(this, 'render');
      self.plugin = new PluginCollection;
      self.plugin.query = new Parse.Query(PluginModle);
      self.plugin.query.equalTo("user", user);
      return self.plugin.fetch({
        success: function() {
          return self.render(name);
        }
      });
    },
    render: function() {
      var $el, compiledTemplate, self;
      self = this;
      $el = this.$el;
      compiledTemplate = Mustache.render($(Template).find('.view').html(), {});
      self.$el.html(compiledTemplate);
      self.plugin.each(function(plug) {
        return self.renderPlugin(plug);
      });
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      return $('.loader').fadeOut(100);
    },
    renderPlugin: function(plug) {
      var $el, $this, plugTemplage, self, user, username;
      self = this;
      $el = this.$el;
      user = Parse.User.current();
      username = user.getUsername();
      plugTemplage = Mustache.render($(Template).find('.item').html(), {
        name: plug.get("name"),
        unmin: plug.get("unminified"),
        min: plug.get("minified"),
        readme: plug.get("readme")
      });
      $this = $(plugTemplage).appendTo(self.$el.find('.plugins'));
      $this.submit(function(e) {
        var min, name, readme, unmin;
        e.preventDefault();
        name = $this.find(".name").val();
        readme = $this.find(".readme").val();
        unmin = $this.find(".unminified-link").val();
        min = $this.find(".minified-link").val();
        plug.set("developer", username);
        plug.set("name", name);
        plug.set("readme", readme);
        plug.set("unminified", unmin);
        plug.set("minified", min);
        return plug.save({
          success: function() {
            return swal("Updated!", "", "success");
          },
          error: function(user, error) {
            return swal("Error!", error.message, "error");
          }
        });
      });
      return $this.find(".delete").click(function(e) {
        e.preventDefault();
        return swal({
          title: "Are you sure?",
          text: "This action can not be undone!",
          type: "warning",
          showCancelButton: true,
          confirmButtonClass: "btn-danger",
          confirmButtonText: "Yes, delete it!"
        }, function() {
          plug.destroy();
          return $this.fadeOut(function() {
            return $this.remove();
          });
        });
      });
    },
    newPlugin: function(e) {
      var plugin, pluginACL, self, user, username;
      self = this;
      user = Parse.User.current();
      username = Parse.User.current().getUsername();
      plugin = new PluginModle({
        user: user,
        developer: username
      });
      pluginACL = new Parse.ACL(Parse.User.current());
      pluginACL.setPublicReadAccess(true);
      plugin.setACL(pluginACL);
      return plugin.save(null, {
        success: function(plug) {
          return self.renderPlugin(plug);
        },
        error: function(user, error) {
          return swal("Error!", error.message, "error");
        }
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
