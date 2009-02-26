function sortMemberTable() {
  $("table#members").tablesorter({ 
    sortList: [[0,0]],
    widgets: ['zebra'],
    headers: { 
      5: { sorter:'currency' },  // Loot Factor
      6: { sorter: 'currency' }, // BiS
      7: { sorter:'currency'} }, // Sit
  });
}

// Hide the flash success message after giving the user 4s to read it
// Don't hide the error messages; we probably want to give them more time to be
// processed by the user
function hideSuccessFlash() {
  setTimeout(function() {
    $('div#flash.success').fadeOut('slow')
  }, 4000);
}

function toggleItemTypes(object) {
  if ($(object).hasClass('bis'))
  {
    type = 'bis'
  }
  else if ($(object).hasClass('sit'))
  {
    type = 'sit'
  }
  else if ($(object).hasClass('rot'))
  {
    type = 'rot'
  }
  else if ($(object).hasClass('de'))
  {
    type = 'de'
  }
  
  if ($(object).hasClass('shown'))
  {
    // This span was clicked and then clicked again; remove it as a filter
    $('#items tbody > tr > td > span').each(function() {
      $(this).removeClass('shown');
      $(this).parent().parent().removeClass('shown');
      $(this).parent().parent().show();
    });
  }
  else
  {
    // Clicked once, only show rows of this type
    $(object).addClass('shown');
    $(object).parent().parent().addClass('shown');
    
    $('#items tbody > tr > td > span.' + type).each(function() {
      if ($(this).parent().parent().hasClass('item_' + type))
      {
        $(this).addClass('shown');
        $(this).parent().parent().addClass('shown');
        $(this).parent().parent().show();
      }
      else
      {
        $(this).removeClass('shown');
        $(this).parent().parent().removeClass('shown');
        $(this).parent().parent().hide();
      }
    });
    
    $('#items tbody > tr:not(.shown)').hide();
  }
}