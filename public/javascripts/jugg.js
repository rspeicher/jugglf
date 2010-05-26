$(document).ready(function() {
    // Make success messages clickable to hide them
    $('div.message.success').click(function() {
      $(this).fadeOut('slow');
    });

    JuggLF.itemFilter.init();
    JuggLF.moderation.init();
    JuggLF.tablesorter.init();

    // Add tooltips to '.help' objects
    $('.help').tooltip({ showURL: false });

    $("#ajax_loading").bind("ajaxSend", function() {
      $(this).show();
    }).bind("ajaxComplete", function() {
      $(this).hide();
    }).bind("ajaxSuccess", function() {
      // Call these again so we apply them for any pages that were loaded via AJAX.
      JuggLF.itemFilter.init();
      JuggLF.moderation.init();
      // JuggLF.tablesorter.init(); // FIXME: Causes unwanted behavior with wishlist form (duplicate rows)
    });
});

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
    var count = 0;

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
