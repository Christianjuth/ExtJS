define(["jquery", "underscore", "backbone", "parse", "text!templates/404.html"], function($, _, Backbone, Parse, Template) {
  var View;
  View = Backbone.View.extend({
    el: $('.content'),
    render: function() {
      var compiledTemplate, data;
      data = {};
      compiledTemplate = _.template(Template, data);
      this.$el.html(compiledTemplate);
      if (window.innerWidth < 850) {
        $(".sidebar .links").slideUp();
        $(".sidebar").attr("toggle", "false");
      }
      return $('.loader').fadeOut(100);
    }
  });
  return View;
});
