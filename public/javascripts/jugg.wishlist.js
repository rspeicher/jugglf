function clearWishlistForm(which) {
    // Hide the errors div
    $(which + ' div.messages').addClass('hide');
    
    // Clear the values of the previous input
    $(which + ' #wishlist_wow_id').val('');
    $(which + ' input[type=text]').each(function() {
        $(this).val('');
    });
    $(which + ' #wishlist_priority_normal').attr('checked', 'checked');
}

function showWishlistForm(which) {
    console.log(which);
    
    // Show the New form
    $(which).show();

    // Focus the first field
    $(which + ' #wishlist_item_name').focus();
    
    // Hide the 'Add Entry' button so people don't confuse it with the Submit
    $('#wishlist_form_toggle').hide();
    
    // Add autocompletion if it doesn't already have it
    if (!$(which + ' #wishlist_item_name').hasClass('ac_input')) {
        $(which + ' #wishlist_item_name').autocomplete_items();
    }
    
    // When an autocomplete result is selected, change the value of the wow_id input
    $(which + ' #wishlist_item_name').result(function(event, data, formatted) {
      $(which + ' #wishlist_wow_id').val(data.item.wow_id);
    });
}

(function($)
{
    $.extend({
        wishlist_form: new function() {
            // Private
            function clear_form(f) {
            }
            
            function show_form(f) {
            }

            // Public
            this.construct = function(settings) {
                return this.each(function() {
                    clear_form(this);
                    show_form(this);
                });
            };
        }
    });
    
    // extend plugin scope
    $.fn.extend({
        wishlist_form: $.wishlist_form.construct
    });


    // -------------------------------------------------------------------------
    
    $.extend({
        // wishlist_form: {
        //     hide: function() {
        //         this.clear();
        //         $('#wishlist_form').hide();
        //         $('#wishlist_form_toggle').show();
        //     }
        // },
        
        wishlists: {
            edit_links: function() {
                $('.wishlist a.edit').live('click', function() {
                  $.get($(this).attr('href'), function(value) {
                    $('#wishlist_form').html(value);
                  });
                  $.wishlist_form.show();
                  return false;
                });
            }
        }
    });
})(jQuery);

/* BEGIN BUGGYNESS ---------------------------------------------------------- */

/**
 * Wipe out an existing 'Edit' form when we want a 'New' form
 */
function wishlistNewForm(path) {
    if ($('#wishlist_form form').attr('id').match(/^edit_/)) {
        $.get(path, function(value) {
            $('#wishlist_form').html(value);
            wishlistForm();
        });
    }
    else {
        wishlistForm();
    }
}

function wishlistEdit() {

}

/* ------------------------------------------------------------ END BUGGYNESS */