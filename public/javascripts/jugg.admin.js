$(function() {
    $('ul.topic_moderation').moderation();
});

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
    str = '/w Tsigo compare [' + $('#loot_table_' + id + ' h4 span:first').text() + '],';
    
    // Build an array of "<Name> <type>" strings
    names = new Array();
    $('#loot_table_' + id + ' table tbody tr').each(function() {
        names.push(
            $(this).children('td:eq(0)').children('a').text() + ' ' + // Name
            $(this).children('td:eq(2)').text().substr(0,3).toLowerCase()); // Tell Type
    });
    str += names.join(',');
    
    prompt("Copy and paste:", str);
}