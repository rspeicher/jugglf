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