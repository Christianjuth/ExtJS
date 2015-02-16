define(['jquery'], function() {
  return $(document).ready(function() {
    $(".sidebar").attr("toggle", "false");
    $(".menu-icon-wrap").click(function() {
      var menuToggle;
      menuToggle = "true" === $(".sidebar").attr("toggle");
      if (window.innerWidth >= 850) {

      } else if (menuToggle === false) {
        $(".sidebar .links").slideDown();
        return $(".sidebar").attr("toggle", "true");
      } else {
        $(".sidebar .links").slideUp();
        return $(".sidebar").attr("toggle", "false");
      }
    });
    return $(window).resize(function() {
      var menuToggle;
      menuToggle = "true" === $(".sidebar").attr("toggle");
      if (window.innerWidth > 850 && !menuToggle) {
        return $(".sidebar .links").show();
      } else if (!menuToggle) {
        return $(".sidebar .links").hide();
      }
    });
  });
});
