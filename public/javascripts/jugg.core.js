/**
 * Generates a unique ID for an element, given a prefix
 *
 * See http://stackoverflow.com/questions/470772/does-jquery-have-an-equivalent-to-prototypes-element-identify
 */
jQuery.fn.identify = function(prefix) {
    var i = 0;
    return this.each(function() {
        if ($(this).attr('id')) return;
        do {
            i++;
            var id = prefix + '_' + i;
        } while($('#' + id).length > 0);
        $(this).attr('id', id);
    });
};

/**
 * Inline moderation for any object
 */
(function($) {
    $.extend({
        moderation: new function() {
            var showMod = [];

            // Private
            function setup(mod) {
                cell = $(mod).parent('td');
                $(mod).hide();
                $(mod).identify('moderation');

                $(cell).mouseover(showModeration);
                $(mod).mouseover(function() {
                    $(this).css('cursor', 'pointer');
                    $(this).fadeTo(1, 1.0);
                });

                $(mod).mouseover(function(e) {
                    $(mod).css('cursor', 'pointer');
                    e.stopPropagation();
                });
                $(mod).mouseout(function(e) {
                    e.stopPropagation();
                });
            }
            
            function showModeration(e) {
                hideAllModeration();
                
                elem = e.target
                if (elem != document) {
                    theUL = $(elem).find('ul.topic_moderation');
                    theUL.fadeTo('fast', 0.3).show();
                    showMod.push(theUL);
                }
                
                // e.stopPropagation(); // Breaks Wowhead tooltips
            }
            
            function hideAllModeration() {
                $.each(showMod, function() {
                    $(this).hide();
                });
            }

            // Public
            this.construct = function(settings) {
                return this.each(function() {
                    setup(this);
                });
            };
        }
    });
    
    // extend plugin scope
    $.fn.extend({
        moderation: $.moderation.construct
    });
})(jQuery);