function sortMemberTable() {
    $("table#members").tablesorter({ 
        sortList: [[0,0]],
        widgets: ['zebra'],
        headers: { 
            5: { sorter:'currency' },     // Loot Factor
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

/*
    Takes a tbody#itemfilter > tr > td > span object and toggles filtering by
    that particular type of loot (BiS, Sit, Rot, Disenchant). Also handles
    re-applying even/odd row classes so that the alternating background colors
    are maintained even if an 'odd' row gets filtered out while the two 
    surrounding 'even' rows are shown.
*/
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
    
    parentRow = $(object).parent().parent();

    // If our parent row is .shown, then we need to toggle this filter off and show all rows
    if ($(parentRow).hasClass('shown'))
    {
        background = 'even';
        $('#itemfilter tr').each(function() {
            $(this).removeClass('even');
            $(this).removeClass('odd');
            $(this).addClass(background);
            background = $(this).hasClass('even') ? 'odd' : 'even';
            
            $(this).show();
            $(this).removeClass('shown');
        });
    }
    else
    {
        background = null;
        $('#itemfilter tr').each(function() {
            if ($(this).hasClass('loot_' + type))
            {
                // If this row has this tell type, apply 'shown' class
                $(this).addClass('shown');
                
                // Zebra table backgrounds; we only need to do this if a row
                // has already been hidden (background set to non-null below)
                if (background != null)
                {
                    $(this).removeClass('even');
                    $(this).removeClass('odd');
                    $(this).addClass(background);
                    background = (background == 'even' ) ? 'odd' : 'even';
                }
            }
            else
            {
                // Otherwise hide this row
                $(this).hide();
                
                if (background == null)
                {
                    background = ($(this).hasClass('even')) ? 'even' : 'odd';
                }
            }
        });
    }
}