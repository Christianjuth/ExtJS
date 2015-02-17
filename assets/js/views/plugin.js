define(["jquery", "underscore", "mustache", "backbone", "parse", "highlight", "marked", "text!templates/404.html"], function($, _, Mustache, Backbone, Parse, hljs, marked, Err) {
  var PluginCollection, PluginModle, View;
  PluginModle = Parse.Object.extend("Plugin", {});
  PluginCollection = Parse.Collection.extend({});
  View = Backbone.View.extend({
    el: $('.content'),
    initialize: function(options) {
      var name, self;
      self = this;
      name = options.plugin;
      _.bindAll(this, 'render');
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
      var $el, Template, compiledTemplate, plug;
      $el = this.$el;
      plug = this.plugin.at(0);
      Template = plug.get('readme');
      compiledTemplate = marked(Template);
      $el.html(compiledTemplate);
      $('pre > code').each(function(i, block) {
        return hljs.highlightBlock(block);
      });
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
