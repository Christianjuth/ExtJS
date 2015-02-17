define(["jquery", "underscore", "mustache", "backbone", "parse", "text!templates/404.html"], function($, _, Mustache, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    render: function() {
      var compiledTemplate;
      compiledTemplate = Mustache.render(Template, {});
      this.$el.html(compiledTemplate);
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
