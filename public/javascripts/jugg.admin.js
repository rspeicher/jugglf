/**
 * Given a price_loot_path value, fetch the value of the item and update the
 * loot_price field to the returned value.
 */
function findItemPrice(path) {
    $.get(path, {}, function(data) {
        $('#loot_price').val(data);
        $('#loot_price').effect('highlight', {}, 1500);
    });
}

/**
 * Prompt the user with a string to copy that allows them to whisper someone
 * in WoW for an in-game comparison from JuggyCompare
 */
function wishlistCompare(id) {
    // Whisper, item name
    str = '/w Tsigo compare [' + $('#loot_table_' + id + ' p.posted_info span:first').text() + '],';
    
    // Build an array of "<Name> <type>" strings
    names = new Array();
    $('#loot_table_' + id + ' table tbody tr').each(function() {
        names.push(
            $(this).find('td.member span.larger a').text() + ' ' + // Name
            $(this).children('td:eq(1)').text().substr(0,3).toLowerCase()); // Tell Type
    });
    str += names.join(',');
    
    prompt("Copy and paste:", str);
}

function attendanceEditLoot(id) {
    loot_row   = '#live_loot_' + id;
    
    item_name  = $(loot_row + ' > td:nth-child(1) > a').text();
    wow_id     = parseInt($(loot_row + ' > td:nth-child(1) > a').attr('rel').replace(/[^0-9]+/, ''));
    buyer_name = $(loot_row + ' > td:nth-child(2) > a').text();
    loot_type  = $(loot_row + ' > td:nth-child(3)').text();
    
    // Build the string that the parser expects
    loot_string = ''
    loot_string += (buyer_name == '') ? 'DE' : buyer_name;
    loot_string += (loot_type  == '') ? '' : ' ' + loot_type;
    loot_string += ' - ';
    loot_string += item_name + '|' + wow_id;
    loot_string += "\n";
    
    // Highlight the text area; focus it
    $('#live_loot_input_text').val($('#live_loot_input_text').val() + loot_string);
    $('#live_loot_input_text').effect('highlight', {}, 500);
    $('#live_loot_input_text').focus();
}