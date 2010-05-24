(function($)
{
    /**
     * Adds jQuery Autocomplete for use on an 'Item Name' field
     *
     * Search results have an item icon, a colorzed item name and include the
     * slot and whether or not the item is Heroic.
     *
     * Example:
     *  $('#item_name').autocomplete_items();
     */
    $.fn.autocomplete_items = function()
    {
        return this.each(function()
        {
            $(this).autocomplete('/search/items.json', {
                minChars: 2,
                dataType: 'json',
                scrollHeight: 260,
                parse: function(data) {
                    var array = [];
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].item) {
                            var icon = ( data[i].item.icon ) ? data[i].item.icon.toLowerCase() : 'inv_misc_questionmark';
                            var slot = ( data[i].item.slot === null ) ? 'Token' : data[i].item.slot;
                            var heroic = ( data[i].item.heroic ) ? ' (Heroic)' : '';
                            var formatted = "<img src='http://static.wowhead.com/images/wow/icons/medium/" + icon + ".jpg'/>" +
                              "<span class='" + data[i].item.color + "'>" + data[i].item.name + "</span>" +
                              "<br/>" + data[i].item.level + " " + slot + heroic;

                            array[array.length] = {
                                data: data[i],
                                value: formatted,
                                result: this.formatResult(data[i].item)
                            };
                        }
                    }
                    return array;
                },
                formatResult: function(item) {
                    return item.name;
                },
                formatItem: function(row, i, max, value) {
                    return value;
                }
            });
        });
    };

    /**
     * Adds jQuery Autocomplete for use on a 'Member Name' field
     *
     * Example:
     *  $('#member_name').autocomplete_members();
     */
    $.fn.autocomplete_members = function()
    {
        return this.each(function()
        {
            $(this).autocomplete('/search/members.json', {
                minChars: 1,
                dataType: 'json',
                parse: function(data) {
                    var array = [];
                    for (var i = 0; i < data.length; i++) {
                        if (data[i].member) {
                            array[array.length] = {
                                data: data[i],
                                value: data[i].member.name,
                                result: data[i].member.name
                            };
                        }
                    }
                    return array;
                },
                formatItem: function(row, i, max, value) {
                    return value;
                }
            });
        });
    };
})(jQuery);
