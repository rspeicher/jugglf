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