function setupModeration() {
    $('ul.topic_moderation').moderation();
}

$(document).ready(function() {
    // Make the page viewable to those allowing Javascript
    // $('#ipbwrapper').removeClass('hide');

    // Make success messages clickable to hide them
    $('div.message.success').click(function() {
        $(this).fadeOut('slow');
    });

    setupModeration();

    $("#ajax_loading").bind("ajaxSend", function() {
        $(this).show();
     }).bind("ajaxComplete", function() {
        $(this).hide();
     });
});

// function initToggles() {
//     $('.toggle').click(function() {
//     });
// }

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
    $('div.author_info ul ul').each(function() {
        if ($(this).attr('id') != 'loot_table_' + zone) {
            $(this).hide();
        }
        else {
            $(this).removeClass('hide');
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
        wishes = $(this).children('table.ipb_table').children('tbody').children('tr').length;
        if (wishes == 0) {
            $(this).hide();
            count++;
        }

        // Hide the clipboard icon if 0 or 1 people want this, since there'd be nothing to compare
        if (wishes == 0 || wishes == 1) {
            $(this).children('p.posted_info').children('a').hide();
        }
    });

    if (count > 0) {
        $('div.notice').html("<b>Note:</b> Hiding " + count + " unwanted items. " +
            "<a onclick=\"wishlistShowUnwanted(); return false;\" href=\"#\">Click here</a> to show them.");
        $('div.notice').removeClass('hide');
    }
}

function wishlistShowUnwanted() {
    $('div.loot_table').each(function() {
        $(this).show();
    });

    $('div.notice').addClass('hide');
}



function wishlistShowForm() {
    $('#wishlist_form').show();
    $('#wishlist_form_toggle').hide();

    // Autocomplete item name
    $('#wishlist_item_name').unautocomplete();
    $('#wishlist_item_name').autocomplete_items();
    $('#wishlist_item_name').result(function(event, data, formatted) {
      $('#wishlist_item_id').val(data.item.id);
    });

    $('#wishlist_item_name').focus();
}

function wishlistHideForm() {
    $('#wishlist_form').hide();
    $('#wishlist_form_toggle').show();
}

function wishlistCleanForm() {
    // Hide the errors div
    $('#wishlist_form div.messages').addClass('hide');

    // Clear the values of the previous input
    $('#wishlist_form #wishlist_item_id').val('');
    $('#wishlist_form #wishlist_priority_normal').attr('checked', 'checked');
    $('#wishlist_form input[type=text]').each(function() { $(this).val(''); });

    $('#wishlist_item_name').focus();
}

function wishlistEditLinks() {
    $('.wishlist a.edit').live('click', function() {
      $.get($(this).attr('href'), function(value) {
        wishlistCleanForm();
        $('#wishlist_form').html(value);
        wishlistShowForm();
      });

      return false;
    });

    $('#wishlist_form_toggle a').click(function() {
        // Edit form replaced us, fetch the New form
        if ($('#wishlist_form form').attr('id').match(/^edit_/)) {
            $.get($(this).attr('href'), function(value) {
                $('#wishlist_form').html(value);
                wishlistCleanForm();
                wishlistShowForm();
            });
        }
        else {
            wishlistCleanForm();
            wishlistShowForm();
        }

        return false;
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
    if      ($(object).hasClass('bis'))    { type = 'bis'; }
    else if ($(object).hasClass('sit'))    { type = 'sit'; }
    else if ($(object).hasClass('rot'))    { type = 'rot'; }
    else if ($(object).hasClass('de'))     { type = 'de';  }
    else if ($(object).hasClass('normal')) { type = 'normal'; }

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