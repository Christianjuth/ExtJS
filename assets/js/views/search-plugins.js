define(["jquery", "underscore", "mustache", "parse", "highlight", "text!templates/search-plugins.html"], function($, _, Mustache, Parse, hljs, Template) {
  var PluginCollection, PluginModle, View;
  PluginModle = Parse.Object.extend("Plugin", {});
  PluginCollection = Parse.Collection.extend({});
  View = Parse.View.extend({
    el: $('.content'),
    initialize: function() {
      var search, self;
      self = this;
      _.bindAll(this, 'render');
      search = this.options.search;
      return self.render(search);
    },
    render: function(search) {
      var $el, self;
      self = this;
      $el = this.$el;
      self.$el.html($(Template).find('.view').html());
      $el.find('.plugins tbody').empty();
      $el.find('.search').val(search);
      $el.find('.search').keyup(function() {
        return self.search($(this).val());
      });
      self.search(search);
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      $('pre > code').each(function(i, block) {
        return hljs.highlightBlock(block);
      });
      return $('.loader').fadeOut(100);
    },
    search: function(search) {
      var $el, developerQuery, nameQuery, self;
      self = this;
      $el = this.$el;
      this.plugins = new PluginCollection;
      nameQuery = new Parse.Query(PluginModle);
      nameQuery.contains("search", search);
      developerQuery = new Parse.Query(PluginModle);
      developerQuery.contains("developer", search);
      this.plugins.query = Parse.Query.or(nameQuery, developerQuery);
      this.plugins.query.notEqualTo("name", "");
      this.plugins.query.ascending("name");
      this.plugins.fetch({
        success: function() {
          return self.searchRender();
        }
      });
      $el = this.$el;
      return Parse.history.navigate("search/plugins?" + search, {
        replace: true
      });
    },
    searchRender: function() {
      var $el, self;
      self = this;
      $el = this.$el;
      $el.find('.plugins tbody').empty();
      return self.plugins.each(function(plug) {
        var plugTemplate;
        plugTemplate = Mustache.render($(Template).find('.item').html(), {
          name: plug.get('name'),
          min: plug.get('minified'),
          unmin: plug.get('unminified'),
          developer: plug.get('developer')
        });
        return $el.find('.plugins tbody').append(plugTemplate);
      });
    }
  });
  return View;
});
