#wait for jquery module
#to be loaded then call
define ['jquery'], ->

  #wait for document to load
  $(document).ready ->

    #set vars
    $('.menu-sidebar').attr 'toggle','false'

    #menu icon click
    $('.menu-icon-wrap').click ->
      menuToggle = 'true' is $('.menu-sidebar').attr 'toggle'
      if window.innerWidth >= 850

      else if menuToggle is false
        $('.menu-sidebar .links').slideDown()
        $('.menu-sidebar').attr 'toggle','true'

      else
        $('.menu-sidebar .links').slideUp()
        $('.menu-sidebar').attr 'toggle','false'


    #reset on resize
    $(window).resize ->
      menuToggle = 'true' is $('.menu-sidebar').attr 'toggle'
      if window.innerWidth > 850 and !menuToggle
        $('.menu-sidebar .links').show()
      else if !menuToggle
        $('.menu-sidebar .links').hide()
