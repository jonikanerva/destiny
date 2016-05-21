$ ->
  $('#weapons').DataTable({
    "paging": false
    "info": false
    "order": [[1, 'desc']]
    "language": {
      "search": ""
    }
  });

  $('tr.active').on 'click', ->
    if event.target.type != 'checkbox'
      $(':checkbox', this).trigger('click')
