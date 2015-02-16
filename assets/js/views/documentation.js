define(["jquery", "underscore", "parse", "highlight", "text!templates/404.html"], function($, _, Parse, hljs, Err) {
  var View;
  View = Parse.View.extend({
    el: $('.content'),
    render: function(file) {
      var Template, compiledTemplate, data;
      data = {};
      Template = "";
      $.ajax({
        type: "GET",
        url: "//ext-js.org/templates/docs/" + file + ".html",
        async: false,
        success: function(data) {
          return Template = data;
        },
        error: function() {
          return Template = Err;
        }
      });
      if (/^(<html>|<body>|<!doctype)/i.test(Template)) {
        Template = Err;
      }
      compiledTemplate = _.template(Template, data);
      this.$el.html(compiledTemplate);
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
