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

/* Members ------------------------------------------------------------------ */

function membersTableSort() {
    $("table#members").tablesorter({
        sortList: [[1,0]],
        widgets: ['zebra'],
        headers: {
            6: { sorter: 'currency' }, // Loot Factor
            7: { sorter: 'currency' }, // BiS
            8: { sorter: 'currency' }  // Sit
        }
    });
}

function membersContextMenu() {
    $('tbody tr td.member').contextMenu({ menu: 'contextMenu' }, function(action, el, pos) {
        if (action == 'edit')
        {
            location.href = el.children('a').attr('href') + '/edit'
        }
        else if (action == 'delete')
        {
            if (confirm('Are you sure you want to delete this record?'))
            {
                var f = document.createElement('form');
                f.style.display = 'none';
                el.parent().append(f);
                f.method = 'POST';
                f.action = el.children('a').attr('href');
                var m = document.createElement('input');
                m.setAttribute('type', 'hidden');
                m.setAttribute('name', '_method');
                m.setAttribute('value', 'delete');
                f.appendChild(m);
                var s = document.createElement('input');
                s.setAttribute('type', 'hidden');
                s.setAttribute('name', 'authenticity_token');
                s.setAttribute('value', 'TODO: Authenticity token');
                f.appendChild(s);f.submit(); 
            };
            return false;
        }
    });
}

/* Raids -------------------------------------------------------------------- */

function raidsContextMenu() {
    $('tbody tr td.date').contextMenu({ menu: 'contextMenu' }, function(action, el, pos) {
        if (action == 'edit')
        {
            location.href = el.children('a').attr('href') + '/edit'
        }
    });
}

/* Wishlists ---------------------------------------------------------------- */

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
        $(this).children('thead').hide();
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
    $('div.item-group').each(function() {
        if ($(this).children('table.list').children('tbody').children('tr').length == 0) {
            $(this).hide();
        }
    });
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
        $('#wishlist_item_name').focus();
        $('#wishlist-toggle').hide();
        $('#wishlist-new').hide();
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
    if      ($(object).hasClass('bis')) { type = 'bis' }
    else if ($(object).hasClass('sit')) { type = 'sit' }
    else if ($(object).hasClass('rot')) { type = 'rot' }
    else if ($(object).hasClass('de'))  { type = 'de'  }

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

    zebraRows($(parentRow).attr('id'));
}