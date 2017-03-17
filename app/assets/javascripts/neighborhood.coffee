# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'click', '.tooltipster', ->
  $tooltip = $(this)

  if !$tooltip.hasClass('tooltipstered')
    $tooltip.tooltipster(trigger: 'click', maxWidth: 500)
    $tooltip.tooltipster('open')
