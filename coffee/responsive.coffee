#wait for jquery module
#to be loaded then call
define ['jquery'], ->

  #wait for document to load
  $(document).ready ->

    #set vars
    $('.sidebar').attr 'toggle','false'
    $('.sidebar .links > li > span').click ->
      $this = $(this).parent()
      #reset
      $('.sidebar .links > li').not($this).removeClass('active')
      $('.sidebar .links > li > ul').not($this).slideUp(500)
      #set current
      if $this.hasClass('active')
        $this.removeClass('active')
        $this.find('ul').slideUp(500)
      else
        $this.addClass('active')
        $this.find('ul').slideDown(500)


    #menu icon click
    $('.menu-icon-wrap').click ->
      menuToggle = 'true' is $('.sidebar').attr 'toggle'
      if window.innerWidth >= 850

      else if menuToggle is false
        $('.sidebar .links').slideDown()
        $('.sidebar').attr 'toggle','true'

      else
        $('.sidebar .links').slideUp()
        $('.sidebar').attr 'toggle','false'


    #reset on resize
    $(window).resize ->
      menuToggle = 'true' is $('.sidebar').attr 'toggle'
      if window.innerWidth > 850 and !menuToggle
        $('.sidebar .links').show()
      else if !menuToggle
        $('.sidebar .links').hide()
