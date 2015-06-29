class TrendingGraph
  constructor: (container) ->
    klass = this

    @container = container
    @datasets = []
    @labels = [2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015]

    $(document).on 'click', '#' + @container + ' .graph-legend li:not(.active)', (e) ->
      klass.addClickedDataSet($(this))

    $(document).on 'click', '#' + @container + ' .graph-legend li.active', (e) ->
      $(@).removeClass('active')
      klass.removeDataSet($(this).data('dataset-id'))

  renderGraph: ->
    data = {
      labels: @labels,
      datasets: @datasets
    };

    canvas = $('#' + @container + ' canvas').get(0)

    if canvas        
      ctx = canvas.getContext("2d");

      if(data.labels.length <= 0 || data.datasets.length <= 0)
        data.datasets[0] = {data: []}

      myNewChart = new Chart(ctx).Line(data, {
        responsive: true,
        maintainAspectRation: true
      });

  addClickedDataSet: ($legendElement) ->
    klass = this
    $graphLegend = $legendElement.closest('.graph-legend')
    $graphLegend.hide()
    $loadingIndicator = $('<div class="loading-indicator"><i class="fa fa-refresh fa-spin"></i></div>')
                          .insertAfter($graphLegend)

    $.ajax 
      url: $legendElement.data('url')
      success: (data, textStatus, jqXHR) -> 
        $legendElement.addClass('active')
        $graphLegend.show()
        $loadingIndicator.remove()
        dataSet = klass.buildDataSet($legendElement, data)
        klass.addDataSet(dataSet)

  buildDataSet: ($legendElement, data) ->
    backgroundColor = 'rgba(' + $legendElement.find('.data-color').css('backgroundColor').substr(4,11) + ', 0.2)'

    dataSet = {}
    dataSet.id = $legendElement.data('dataset-id');
    dataSet.fillColor = backgroundColor;
    dataSet.strokeColor = $legendElement.find('.data-color').css('backgroundColor');
    dataSet.highlightFill = $legendElement.find('.data-color').css('backgroundColor');
    dataSet.label = $legendElement.data('title')
    dataSet.data = []
    dataSet.data.push parseInt(data[year]) || 0 for year in @labels

    return dataSet

  addDataSet: (dataSet) ->
    @datasets.push dataSet
    @renderGraph()

  removeDataSet: (id) ->
    @datasets = (dataset for dataset in @datasets when dataset.id != id)
    @renderGraph()

window.TrendingGraph = TrendingGraph
