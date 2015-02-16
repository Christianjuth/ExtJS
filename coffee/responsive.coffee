#wait for jquery module
#to be loaded then call
define ['jquery'], ->

  #wait for document to load
  $(document).ready ->

    #set vars
    $(".sidebar").attr "toggle","false"

    #menu icon click
    $(".menu-icon-wrap").click ->
      menuToggle = "true" is $(".sidebar").attr "toggle"
      if window.innerWidth >= 850

      else if menuToggle is false
        $(".sidebar .links").slideDown()
        $(".sidebar").attr "toggle","true"

      else
        $(".sidebar .links").slideUp()
        $(".sidebar").attr "toggle","false"

    #reset on resize
    $(window).resize ->
      menuToggle = "true" is $(".sidebar").attr "toggle"
      if window.innerWidth > 850 and !menuToggle
        $(".sidebar .links").show()
      else if !menuToggle
        $(".sidebar .links").hide()
