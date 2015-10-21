$(document).on('click', '#neighborhood-sub-tabs a', function(e) {
  var $this = $(this),
      $clickedTab = $($this.data('target'));

  $clickedTab.closest('.tab-content').find('.tab-pane').removeClass('active');
  $clickedTab.addClass('active');
});
