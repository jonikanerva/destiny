$ ->
  $('#weapons').DataTable({
    "paging": false
    "info": false
    "order": [[2, 'desc']]
    "language": {
      "search": ""
    }
  });

  $('tr.active').on 'click', ->
    if event.target.type != 'checkbox'
      $(':checkbox', this).trigger('click')
