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
                headers: { 2: { sorter: 'wishlist' }, 3: { sorter: 'currency' } }
            });
        }
    });
}

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