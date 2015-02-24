define(["jquery", "underscore", "mustache", "backbone", "parse", "marked", "highlight", "text!templates/404.html"], function($, _, Mustache, Backbone, Parse, marked, hljs, Err) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    initialize: function(options) {
      var self;
      self = this;
      self.options = options;
      _.bindAll(this, 'render');
      return this.render();
    },
    render: function() {
      var Template, compiledTemplate, data, options, self;
      self = this;
      options = self.options;
      data = {};
      Template = "";
      $.ajax({
        type: "GET",
        url: "//ext-js.org/collections/documentation/" + options.file + ".md",
        async: false,
        success: function(data) {
          return Template = marked(data);
        },
        error: function() {
          return Template = Err;
        }
      });
      if (/^(<html>|<body>|<!doctype)/i.test(Template)) {
        Template = Err;
      }
      compiledTemplate = Mustache.render(Template, {});
      this.$el.html(compiledTemplate);
      $('pre > code').each(function(i, block) {
        return hljs.highlightBlock(block);
      });
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
