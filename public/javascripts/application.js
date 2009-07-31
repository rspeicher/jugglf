/**
 * Re-applies alternating row colors to a specific tbody after a specified delay.
 *
 * tbody_id     String      ID of the tbody to apply zebra rows to
 * delay        Integer     Delay, in miliseconds, after which to apply the effect (default: 0)
 */
function zebraRows(tbody_id, delay) {
    delay = (delay == null) ? 0: delay

    setTimeout(function() {
        background = 'even';
        $('tbody#' + tbody_id + ' > tr:visible').each(function() {
            $(this).removeClass('even');
            $(this).removeClass('odd');
            $(this).addClass(background);
            background = (background == 'even') ? 'odd': 'even';
        });
    }, delay);
}

// Hide the flash success message after giving the user 4s to read it
// Don't hide the error messages; we probably want to give them more time to be
// processed by the user
function hideSuccessFlash() {
    setTimeout(function() {
        $('div#flash.success').fadeOut('slow')
    }, 4000);
}

function bindWithActions() {
    $('td.with_actions').hover(function() {
        $(this).children('ul.actions').fadeIn('fast');
    }, function() {
        $(this).children('ul.actions').hide();
    });
}

function addItemAutoComplete(field) {
    $(field).autocomplete('/search/items.js', {
      minChars: 2,
      dataType: 'json',
      parse: function(data) {
          var array = new Array();
          for (var i = 0; i < data.length; i++) {
              if (data[i].item) {
                  // var formatted = "<span class=" + data[i].item.color + ">" + data[i].item.name + "</span> (" + data[i].item.level + " " + data[i].item.slot + ")";
                  var formatted = data[i].item.name + " (" + data[i].item.level + " " + data[i].item.slot + ")";
                  array[array.length] = { 
                      data: data[i],
                      value: formatted,
                      result: data[i].item.wow_id
                  }
              };
          }
          return array;
      },
      formatItem: function(row, i, max, value) {
          return value;
      },
    });
}

function addMemberAutoComplete(field) {
    $(field).autocomplete('/search/members.js', {
      minChars: 1,
      dataType: 'json',
      parse: function(data) {
          var array = new Array();
          for (var i = 0; i < data.length; i++) {
              if (data[i].member) {
                  array[array.length] = { 
                      data: data[i], 
                      value: data[i].member.name,
                      result: data[i].member.name
                  }
              };
          }
          
          return array;
      },
      formatItem: function(row, i, max, value) {
          return value;
      },
    });
}

/* Context Menus ------------------------------------------------------------ */
function itemContextMenu() {
    $('tbody tr.item td.item').contextMenu({ menu: 'itemContextMenu' }, function(action, el, pos) {
        if (action == 'edit') {
            window.location.href = el.children('a').attr('href') + '/edit';
        }
    });
}
function lootContextMenu() {
    $('tbody tr.loot td.item').contextMenu({ menu: 'lootContextMenu' }, function(action, el, pos) {
        href = ''
        if (action == 'edit_item') {
            href = el.children('a').attr('href') + '/edit';
        }
        else if (action == 'edit_loot') {
            href = '/loots/' + el.parent().attr('id').replace(/loot_/, '') + '/edit';
        }
        
        if (href != '') {
            window.location.href = href;
        }
    });
}
function memberContextMenu() {
    $('tbody tr td.member').contextMenu({ menu: 'memberContextMenu' }, function(action, el, pos) {
        if (action == 'edit') {
            window.location.href = el.children('a').attr('href') + '/edit'
        }
    });
}
function raidContextMenu() {
    $('tbody tr td.date').contextMenu({ menu: 'raidContextMenu' }, function(action, el, pos) {
        if (action == 'edit') {
            location.href = el.children('a').attr('href') + '/edit'
        }
    });
}

/* Members ------------------------------------------------------------------ */

function membersTableSort() {
    $("#members table#index").tablesorter({
        sortList: [[1,0]],
        widgets: ['zebra'],
        headers: {
            6: { sorter: 'currency' }, // Loot Factor
            7: { sorter: 'currency' }, // BiS
            8: { sorter: 'currency' }  // Sit
        }
    });
}

/* Wishlists ---------------------------------------------------------------- */

/**
 * Sorts a single user's wishlist table, not to be confused with wishlistSortTables
 */
function sortWishlistTable() {
    $("table#wishlists").tablesorter({
        sortList: [[1,0], [0,0]],
        widgets: ['zebra'],
        headers: {
            1: { sorter: 'wishlist' }, // Priority
            4: { sorter: false }       // Don't sort the 'Delete' icon'
        }
    });
    zebraRows('wishlist');
}

/**
 * Sorts each child table of the individual wishlist item entries.
 */
function wishlistSortTables() {
    $('table.tablesorter').each(function() {
        // tablesorter had some errors with trying to sort a table that only had one row
        if ($(this).children('tbody').children('tr').length > 1) {
            $(this).tablesorter({
                sortList: [[2,0], [3,0]],
                widgets: ['zebra'],
                headers: {
                    2: {
                        sorter: 'wishlist'
                    },
                    3: {
                        sorter: 'currency'
                    }
                }
            });
        }
    });
}

/**
 * Filter and style the global wishlist view menu.
 *
 * Hides the boss list for zones we're not currently viewing. Removes the link
 * and bolds the text of the currently viewed boss.
 *
 * zone     integer     ID of the current Zone row
 * boss     integer     ID of the current Boss row
 */
function wishlistMenu(zone, boss) {
    $('#sidebar ul ul').each(function() {
        if ($(this).attr('id') != 'loot_table_' + zone) {
            $(this).hide();
        }
        else {
            $(this).children().each(function() {
                if ($(this).attr('id') == 'loot_table_' + boss) {
                    $(this).html('<b>' + $(this).text() + '</b>');
                }
            });
        }
    });
}

/**
 * Hides item groups for which there are no displayed Wishlist rows. These can
 * be caused by an item having no wishlist entries at all, or an item having no
 * wishlist entries by an active member. Either way, we don't want them displayed.
 */
function wishlistHideUnwanted() {
    count = 0;
    
    $('div.loot_table').each(function() {
        wishes = $(this).children('table.list').children('tbody').children('tr').length;
        if (wishes == 0) {
            $(this).hide();
            count++;
        }
        
        // Hide the clipboard icon if 0 or 1 people want this, since there'd be nothing to compare
        if (wishes == 0 || wishes == 1) {
            $(this).children('h4').children('a').hide();
        }
    });
    
    if (count > 0) {
        $('div.notice').html("<b>Note:</b> Hiding " + count + " unwanted items. " +
            "<a onclick=\"wishlistShowUnwanted(); return false;\" href=\"#\">Click here</a> to show them.")
        $('div.notice').removeClass('hidden');
    }
}

function wishlistShowUnwanted() {
    $('div.loot_table').each(function() {
        $(this).show();
    });
    
    $('div.notice').addClass('hidden');
}

function wishlistCompare(id) {
    // Whisper, item name
    str = '/w Tsigo compare [' + $('#loot_table_' + id + ' h4 span:first').text() + '],';
    
    // Build an array of "<Name> <type>" strings
    names = new Array();
    $('#loot_table_' + id + ' table tbody tr').each(function() {
        names.push(
            // Name
            $(this).children('td:eq(0)').text() +
            ' ' +
            // Type
            $(this).children('td:eq(2)').text().substr(0,3).toLowerCase());
    });
    str += names.join(',');
    
	prompt("Copy and paste:", str);
}

/**
 * Prepares a form for adding a new Wishlist entry
 */
function wishlistAddForm() {
    // Hide the errors div
    $('#errors').addClass('hidden');
    
    // Wipe out any lingering Edit Form data
    $('#wishlist-edit').html('');
    
    // Show the New form, add autocompletion
    $('#wishlist-new').show();
    addItemAutoComplete('#wishlist_item_name')
    
    // Focus the first field
    $('#wishlist-new #wishlist_item_name').focus();
    
    // Clear the values of the previous input
    $('#wishlist-new input[type=text]').each(function() {
        $(this).val('');
    });
    $('#wishlist-new #wishlist_priority_normal').attr('checked', 'checked');
    
    // Hide the 'Add Entry' button so people don't confuse it with the Submit
    $('#wishlist-toggle').hide();
}

/**
 * Fetches a remote Wishlist edit form to be displayed inline.
 *
 * Gets a form for the specified path, then shows the form div, focuses the
 * first input field, and hides the div that toggles a 'New Wishlist Entry'
 * form to avoid confusion by having two sets of buttons.
 *
 * path     string      Path to fetch (e.g., /members/1/wishlists/2/edit)
 */
function wishlistEditForm(path) {
    $.get(path, function(value) {
        $('#wishlist-edit').html(value);
        $('#wishlist-edit').show();
        
        // Hide the button to show the 'New Entry' form
        $('#wishlist-toggle').hide();
        
        // Hide the actual 'New Entry' form
        $('#wishlist-new').hide();
        
        // Add autocompletion to the edit form
        addItemAutoComplete('#wishlist-edit #wishlist_item_name')
        
        $('#wishlist-edit #wishlist_item_name').focus();
    });
}

/* Custom sorter to sort wishlist priorities as Best in Slot > Normal > Rot > Situational */
$.tablesorter.addParser({
    id: 'wishlist',
    is: function(s) {
        return false;
    },
    format: function(s) {
        return s.toLowerCase().replace(/best in slot/, 1).replace(/normal/, 2).replace(/rot/, 3).replace(/situational/, 4);
    },
    type: 'numeric'
});

/**
 * Allows for filtering by item tell (loot) types
 *
 * Takes a tbody#itemfilter > tr > td > span object and toggles filtering by
 * that particular type of loot (BiS, Sit, Rot, Disenchant). Also handles
 * re-applying even/odd row classes so that the alternating background colors
 * are maintained even if an 'odd' row gets filtered out while the two 
 * surrounding 'even' rows are shown.
 *
 * object   jQuery      Object for the clicked span
*/
function toggleItemTypes(object) {
    if      ($(object).hasClass('bis'))    { type = 'bis' }
    else if ($(object).hasClass('sit'))    { type = 'sit' }
    else if ($(object).hasClass('rot'))    { type = 'rot' }
    else if ($(object).hasClass('de'))     { type = 'de'  }
    else if ($(object).hasClass('normal')) { type = 'normal' }

    parentRow = $(object).parent().parent();

    // If our parent row is .shown, then we need to toggle this filter off and show all rows
    if ($(parentRow).hasClass('shown'))
    {
        $('#itemfilter tr').each(function() {
            $(this).show();
            $(this).removeClass('shown');
        });
    }
    else
    {
        $('#itemfilter tr').each(function() {
            if ($(this).hasClass('loot_' + type))
            {
                // If this row has this tell type, apply 'shown' class
                $(this).addClass('shown');
            }
            else
            {
                // Otherwise hide this row
                $(this).hide();
            }
        });
    }

    zebraRows($(parentRow).parent().attr('id'));
}