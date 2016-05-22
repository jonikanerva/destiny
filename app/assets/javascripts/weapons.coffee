$ ->
  # enable datatables
  table = $('#weapons').DataTable {
    "paging": false
    "info": false
    "order": [[3, 'desc']]
    "language": {
      "search": ""
      "searchPlaceholder": "Search weapons"
      "zeroRecords": "No weapons selected for compare"
    }
    'columnDefs': [
      { "orderData" : [1], "targets": [0] }
    ]
    "initComplete": ->
      $('div.dataTables_filter input').focus()
  }

  # clicking a row adds row to compare
  $('tr.active').on 'click', ->
    if event.target.type != 'checkbox'
      $(':checkbox', this).trigger('click')
    else
      row_id    = table.row(this).index()
      input     = $('.compare input', this)
      value     = if input.is(':checked') then 1 else 0

      table.cell(row_id, 1).data(value)

  # changing weapon type from dropdown redirects to its page
  $('#type').on 'change', ->
    window.location = $(this).find('option:selected').val();

  # clicking compare shows only rows that are selected (value 1)
  $('#weapon_compare').on 'click', ->
    table.columns(1).search(1).draw()
    toggle_compare()

  # clicking compare off shows all rows (value 1 or 0)
  $('#weapon_compare_off').on 'click', ->
    table.columns(1).search("0|1", true).draw()
    toggle_compare()

  # changing value toggles different values
  $('#value').on 'change', ->
    type = $(this).find('option:selected').val();

    # loop all cells
    table.cells().every ->
      stat_default = $(this.node()).data('default')
      stat_max = $(this.node()).data('max')
      stat_min = $(this.node()).data('min')

      if type == 'max' && stat_max
        $(this.data(stat_max))
      else if type == 'min' && stat_min
        $(this.data(stat_min))
      else if type == 'default' && stat_default
        $(this.data(stat_default))

# toggle compare on/off buttons
toggle_compare = ->
  $('#weapon_compare').toggle()
  $('#weapon_compare_off').toggle()
