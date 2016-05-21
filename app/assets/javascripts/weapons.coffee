$ ->
  # enable datatables
  table = $('#weapons').DataTable {
    "paging": false
    "info": false
    "order": [[3, 'desc']]
    "language": {
      "search": ""
    }
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

# toggle compare on/off buttons
toggle_compare = ->
  $('#weapon_compare').toggle()
  $('#weapon_compare_off').toggle()
