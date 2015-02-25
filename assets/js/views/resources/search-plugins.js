define(["jquery", "underscore", "mustache", "backbone", "parse", "highlight", "text!templates/resources/search-plugins.html"], function($, _, Mustache, Backbone, Parse, hljs, Template) {
  var PluginCollection, PluginModle, View;
  PluginModle = Parse.Object.extend("Plugin", {});
  PluginCollection = Parse.Collection.extend({});
  View = Backbone.View.extend({
    events: {
      'submit .search-form': 'submit'
    },
    el: $('.content'),
    initialize: function(options) {
      var self;
      self = this;
      _.bindAll(this, 'render');
      self.query = options.query;
      return self.render(self.query);
    },
    render: function(search) {
      var $el, compiledTemplate, self;
      self = this;
      $el = this.$el;
      compiledTemplate = Mustache.render($(Template).find('.view').html(), {});
      self.$el.html(compiledTemplate);
      $el.find('.plugins tbody').empty();
      $el.find('.search').val(search);
      $el.find('.search').on('keydown', function(e) {
        if (e.code === 13 || e.which === 13) {
          return;
        }
        return $el.find('.plugins tbody').html($(Template).find('.empty').html());
      });
      self.search(search);
      return $('.loader').fadeOut(100);
    },
    submit: function(e) {
      var $el, search, self;
      e.preventDefault();
      self = this;
      $el = this.$el;
      search = $el.find('.search').val();
      return self.search(search);
    },
    search: function(search) {
      var $el, developerQuery, nameQuery, self;
      self = this;
      $el = this.$el;
      if (search === null) {
        search = '';
      }
      if (search === self.currentSearch) {
        return;
      }
      self.currentSearch = search;
      $el.find('.search').val(search);
      this.plugins = new PluginCollection;
      nameQuery = new Parse.Query(PluginModle);
      nameQuery.contains("search", search);
      developerQuery = new Parse.Query(PluginModle);
      developerQuery.contains("developer", search);
      this.plugins.query = Parse.Query.or(nameQuery, developerQuery);
      this.plugins.query.notEqualTo("name", "");
      this.plugins.query.notEqualTo("file", null);
      this.plugins.query.ascending("name");
      this.plugins.fetch({
        success: function() {
          return self.searchRender();
        }
      });
      $el = this.$el;
      return Backbone.history.navigate("resources/search-plugins?search=" + search, {
        replace: true
      });
    },
    searchRender: function() {
      var $el, self;
      self = this;
      $el = this.$el;
      $el.find('.plugins tbody').empty();
      return self.plugins.each(function(plug) {
        var $this, developer, name, plugTemplate;
        name = plug.get('name');
        developer = plug.get('developer');
        plugTemplate = Mustache.render($(Template).find('.item').html(), {
          name: name,
          link: name.toLowerCase(),
          developer: developer
        });
        $this = $(plugTemplate).appendTo($el.find('.plugins tbody'));
        return $this.find('.link').click(function(e) {
          e.preventDefault();
          return self.search(developer);
        });
      });
    }
  });
  return View;
});
