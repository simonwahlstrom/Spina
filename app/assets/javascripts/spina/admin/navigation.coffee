ready = ->
  if $('nav#primary ul li ul li.active').length > 0
    $('nav#primary > ul > li').removeClass('active')
    $('nav#primary ul li ul li.active').parents('li').addClass('active')

$(document).on 'turbolinks:load', ready

$(document).on 'click', 'nav#primary a:not(.back-to-main-menu)', (e) ->
  $('nav#primary ul li ul li').removeClass('active')
  $(this).parent().addClass('active')

$(document).on 'click', 'nav#primary > ul > li > a', (e) ->
  if $(this).parent().find('ul').length > 0
    $(this).parent().siblings().removeClass('active')
    $(this).parent().addClass('active')
    $(this).parent().find('.first-item').addClass('active')
