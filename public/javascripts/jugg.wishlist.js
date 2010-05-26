(function($) {
  $.extend(JuggLF, {
    wishlist_form: new function() {
      var editing = false;

      /**
       * Initializes the entire wishlist form
       *
       * - Adds behavior to Edit links to make them display inline
       * - Adds behavior to "Add New Entry" to display the form inline
       * - Adds behavior to "Cancel" on the wishlist form to hide the form
       */
      this.init = function() {
        $('.wishlist a.edit').live('click', this.edit);
        $('#wishlist_form_toggle a').click(this.toggle);
        $('#wishlist_form a.cancel').live('click', this.hide);
      };

      /**
       * Clears the wishlist form for new input
       */
      this.clear = function() {
        // Hide the errors div
        $('#wishlist_form div.messages').addClass('hide');

        // Clear the values of the previous input
        $('#wishlist_form #wishlist_item_id').val('');
        $('#wishlist_form #wishlist_priority_normal').attr('checked', 'checked');
        $('#wishlist_form input[type=text]').each(function() { $(this).val(''); });

        // Focus first field
        $('#wishlist_item_name').focus();

        return false;
      };

      /**
       * Shows the wishlist form, hides the "Add New Entry" toggle button
       *
       * Clears the form for a new entry, and adds autocomplete to the Item Name
       * field
       */
      this.show = function() {
        // If the form is for a new entry, we want to clear it
        if (editing === false) {
          this.clear();
        }

        $('#wishlist_form').show();
        $('#wishlist_form_toggle').hide();

        // Autocomplete item name
        $('#wishlist_item_name').unautocomplete();
        $('#wishlist_item_name').autocomplete_items();
        $('#wishlist_item_name').result(function(event, data, formatted) {
          $('#wishlist_item_id').val(data.item.id); // Set item_id value when result is selected
        });

        // Focus first field
        $('#wishlist_item_name').focus();

        return false;
      };

      /**
       * Hides the wishlist form, shows the "Add New Entry" toggle button
       */
      this.hide = function() {
        $('#wishlist_form').hide();
        $('#wishlist_form_toggle').show();

        return false;
      };

      /**
       * Handler function for each wishlist row's "Edit" link
       *
       * Example:
       *   $('.wishlist a.edit').live('click', JuggLF.wishlist_form.edit);
       */
      this.edit = function() {
        // Take the href attr of the edit link and perform a GET request for it,
        // replacing the value of #wishlist_form with the returned value,
        // then show the form
        $.get($(this).attr('href'), function(value) {
          editing = true;

          $('#wishlist_form').html(value);
          JuggLF.wishlist_form.show();
        });

        return false;
      };

      /**
       * Handler function for the "Add New Entry" toggle button
       *
       * Example:
       *   $('#wishlist_form_toggle a').click(JuggLF.wishlist_form.toggle);
       */
      this.toggle = function() {
        // Edit form replaced us, fetch the New form
        if (editing === true) {
          $.get($(this).attr('href'), function(value) {
            $('#wishlist_form').html(value);
            JuggLF.wishlist_form.show();
          });

          editing = false;
        }
        else {
          JuggLF.wishlist_form.show();
        }

        return false;
      };
    } // wishlist_form
  });
})(jQuery);
