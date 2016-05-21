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

  $('#type').on 'change', ->
    window.location = $(this).find('option:selected').val();
