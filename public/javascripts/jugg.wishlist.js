if (typeof JuggLF === "undefined") {
  var JuggLF = {};
}

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
    }, // wishlist_form

    wishlist: new function() {
      function doMenu(zone_id, boss_id) {
        $('div.author_info ul ul').each(function() {
          // Boss doesn't belong to this zone, so hide it
          if ($(this).attr('id') != 'loot_table_' + zone_id) {
            $(this).hide();
          }
          else {
            // Make sure this boss is shown, since it belongs to this zone
            $(this).removeClass('hide');

            $(this).children().each(function() {
              // Viewing this boss, so unlink it and make it bold
              if ($(this).attr('id') == 'loot_table_' + boss_id) {
                $(this).html('<b>' + $(this).text() + '</b>');
              }
            });
          }
        });
      }

      function hideUnwanted() {
        var hidden = 0;

        $('div.loot_table').each(function() {
          // If a wishlist table has 0 rows, it's an unwanted item, so we can hide the table entirely
          var wishes = $(this).children('table.ipb_table').children('tbody').children('tr').length;
          if (wishes == 0) {
            $(this).hide();
            hidden++;
          }

          // Hide the clipboard icon if 0 or 1 people want this, since there'd be nothing to compare
          if (wishes == 0 || wishes == 1) {
            $(this).children('p.posted_info').children('a').hide();
          }
        });

        if (hidden > 0) {
          $('div.notice.unwanted').html($('div.notice.unwanted').html().replace('{{count}}', hidden));
          $('div.notice.unwanted').removeClass('hide');
        }
      }

      /**
       * Prompt the user with a string to copy that allows them to whisper someone
       * in WoW for an in-game comparison from JuggyCompare
       */
      this.compare = function(id) {
        // Whisper + item name in brackets
        var str = '/w Tsigo compare [' + $('#loot_table_' + id + ' p.posted_info span:first').text().trim() + '],';

        // Build an array of "<Name> <type>" strings
        var pieces = [];
        $('#loot_table_' + id + ' table tbody tr').each(function() {
          name     = $(this).find('td.member span.larger a').text().trim();
          priority = $(this).children('td:eq(1)').text().substr(0,3).toLowerCase().trim();
          piece    = (priority == 'nor') ? name : name + ' ' + priority;

          // Only add one entry per piece (member + type pair)
          if ($.inArray(piece, pieces) < 0) {
            pieces.push(piece);
          }
        });
        str += $.unique(pieces).join(',');

        prompt("Copy and paste:", str);
      };

      this.showUnwanted = function() {
        $('div.loot_table').each(function() {
          $(this).show();
        });

        $('div.notice.unwanted').addClass('hide');
      };

      /**
       * Filter and style the global wishlist view menu.
       *
       * Hides the boss list for zones we're not currently being viewed.
       * Removes the link and bolds the text of the currently viewed boss.
       *
       * zone     integer     ID of the current Zone object
       * boss     integer     ID of the current Boss object
       */
      this.init = function(zone_id, boss_id) {
        doMenu(zone_id, boss_id);
        hideUnwanted();
      };
    } // wishlist
  });
})(jQuery);
