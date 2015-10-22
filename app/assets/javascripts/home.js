$(document).on('click', '#neighborhood-sub-tabs a', function(e) {
  var $this = $(this),
      $clickedTab = $($this.data('target'));

  $clickedTab.closest('.tab-content').find('.tab-pane').removeClass('active');
  $clickedTab.addClass('active');
});

$(document).on('click', '.tooltipster:not(".tooltipster-rendered")', function(e) {
  var $this = $(this);
  $this.addClass('tooltip-rendered');
  $this.tooltipster(
    {
      position: 'bottom',
      content: $($($this.data('content')).html()),
      trigger: 'click',
      theme: 'tooltipster-shadow',
      minWidth: '900px',
      interactive: true
    }
  ).tooltipster('show');
});
