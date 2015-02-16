define(["jquery", "underscore", "parse", "highlight", "marked", "text!templates/404.html"], function($, _, Parse, hljs, marked, Err) {
  var PluginCollection, PluginModle, View;
  PluginModle = Parse.Object.extend("Plugin", {});
  PluginCollection = Parse.Collection.extend({});
  View = Parse.View.extend({
    el: $('.content'),
    initialize: function() {
      var name, self;
      self = this;
      _.bindAll(this, 'render');
      name = this.options.plugin;
      this.plugin = new PluginCollection;
      this.plugin.query = new Parse.Query(PluginModle);
      this.plugin.query.equalTo("search", name.toLowerCase());
      return this.plugin.fetch({
        success: function() {
          return self.render(name);
        }
      });
    },
    render: function(name) {
      var $el, Template, plug;
      $el = this.$el;
      plug = this.plugin.at(0);
      Template = plug.get('readme');
      Template = marked(Template);
      $el.html(Template);
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      $('pre > code').each(function(i, block) {
        return hljs.highlightBlock(block);
      });
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
