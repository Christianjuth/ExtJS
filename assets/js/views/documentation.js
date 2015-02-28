define(["jquery", "underscore", "mustache", "backbone", "parse", "marked", "highlight", "text!templates/documentation/page.html", "text!templates/404.html"], function($, _, Mustache, Backbone, Parse, marked, hljs, Template, Err) {
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
      var compiledTemplate, data, options, self;
      self = this;
      options = self.options;
      data = {};
      compiledTemplate = "";
      $.ajax({
        type: "GET",
        url: "//ext-js.org/collections/documentation/" + options.doc + ".md",
        async: false,
        success: function(data) {
          var doc;
          if (/^(<!doctype|<html>|<body>|<!doctype)/i.test(data)) {
            return compiledTemplate = Err;
          } else {
            doc = marked(data);
            return compiledTemplate = Mustache.render(Template, {
              doc: doc
            });
          }
        },
        error: function() {
          return compiledTemplate = Err;
        }
      });
      this.$el.html(compiledTemplate);
      $('pre > code').each(function(i, block) {
        return hljs.highlightBlock(block);
      });
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
