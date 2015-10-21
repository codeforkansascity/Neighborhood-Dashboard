$(document).on('click', '.statistics-table .glyphicon-plus', function() {
  var $this = $(this);
  $this.removeClass('glyphicon-plus');
  $this.addClass('glyphicon-minus');
  $this.closest('.expandable-row').addClass('expanded');
});

$(document).on('click', '.statistics-table .glyphicon-minus', function() {
  var $this = $(this);
  $this.removeClass('glyphicon-minus');
  $this.addClass('glyphicon-plus');
  $this.closest('.expandable-row').removeClass('expanded');
});
