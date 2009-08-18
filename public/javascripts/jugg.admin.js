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
            // Name
            $(this).children('td:eq(0)').text() +
            ' ' +
            // Type
            $(this).children('td:eq(2)').text().substr(0,3).toLowerCase());
    });
    str += names.join(',');
    
	prompt("Copy and paste:", str);
}

// Context Menus ---------------------------------------------------------------

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