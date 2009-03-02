/**
 * Re-applies alternating row colors to a specific tbody after a specified delay.
 *
 * tbody_id     String      ID of the tbody to apply zebra rows to
 * delay        Integer     Delay, in miliseconds, after which to apply the effect (default: 0)
 */
function zebraRows(tbody_id, delay) {
    delay = ( delay == null ) ? 0 : delay
    
    setTimeout(function() {
        background = 'even';
        $('tbody#' + tbody_id + ' > tr:visible').each(function() {
            $(this).removeClass('even');
            $(this).removeClass('odd');
            $(this).addClass(background);
            background = (background == 'even') ? 'odd' : 'even';
        });
    }, delay);
}

function sortMemberTable() {
    $("table#members").tablesorter({
        sortList: [[0,0]],
        widgets: ['zebra'],
        headers: {
            5: { sorter: 'currency' }, // Loot Factor
            6: { sorter: 'currency' }, // BiS
            7: { sorter: 'currency' }  // Sit
        }
    });
}

function sortWishlistTable() {
    $("table#wishlists").tablesorter({
        sortList: [[2,0], [1,0]],
        widgets: ['zebra'],
        headers: {
            2: { sorter: 'wishlist' }, // Priority
            4: { sorter: false }      // Don't sort the 'Delete' icon'
        }
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

/*
    Takes a tbody#itemfilter > tr > td > span object and toggles filtering by
    that particular type of loot (BiS, Sit, Rot, Disenchant). Also handles
    re-applying even/odd row classes so that the alternating background colors
    are maintained even if an 'odd' row gets filtered out while the two 
    surrounding 'even' rows are shown.
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

/* Custom sorter to sort wishlist priorities as Best in Slot > Normal > Rot > Situational */
$.tablesorter.addParser({
    id: 'wishlist',
    is: function(s) {
        return false;
    },
    format: function(s) { 
        return s.toLowerCase().replace(/best in slot/,1).replace(/normal/,2).replace(/rot/,3).replace(/situational/,4);
    },
    type: 'numeric'
});