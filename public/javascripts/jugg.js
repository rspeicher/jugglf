/**
 * Allow the user to click the #flash.success div in order to hide the message.
 */
function clickableFlash() {
    $('#flash.success').click(function() {
        $(this).fadeOut('slow');
    });
}

/* Wishlists ---------------------------------------------------------------- */

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
            $(this).removeClass('hidden');
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
    $('#wishlist_item_name').result(function(event, data, formatted) {
      $('#wishlist_wow_id').val(data.item.wow_id);
    });
    
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
        $('#wishlist-edit #wishlist_item_name').result(function(event, data, formatted) {
          $('#wishlist-edit #wishlist_wow_id').val(data.item.wow_id);
        });
        
        $('#wishlist-edit #wishlist_item_name').focus();
    });
}

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