(function($) {
  $.extend(JuggLF, {
    itemFilter: new function() {
      /**
       * Adds click event handling to any span in a filterable tbody
       */
      this.init = function() {
        $('.filterable span.filter').click(this.toggle);
      }

      /**
       * Toggle visibility of rows not matching the clicked row's type
       *
       * On a fresh table, if the "Best in Slot" loot type is clicked, any rows
       * not of that type will be hidden from view. Clicking the type again toggles
       * the hidden rows back into view.
       */
      this.toggle = function() {
        var row         = $(this).parent().parent();
        var tbody       = $(row).parent();

        // Each row has a "loot_x" class, so to find out what our filter name should be, just change 'loot' to 'filter'
        var filter_type = $(row).attr('class').replace(/.+(loot_\w+).+/, '$1');

        // We already have hidden rows, so we can assume this is being toggled OFF
        if ($(tbody).children('tr:hidden').length > 0) {
          // Remove the 'filtering' class and show all rows
          $(tbody).children('tr').removeClass('filtering').show();
        }
        else {
          // Toggle ON
          $(tbody).children('tr').filter(function() {
              // Add a 'filtering' class to the row so the CSS can change the background icon
              if ($(this).hasClass(filter_type)) {
                $(this).addClass('filtering');
              }
              // Return true for classes that DON'T have this class, since we're hiding them
              return !$(this).hasClass(filter_type);
          }).hide();
        }

        // Hiding rows likely undid our zebra rows, so get them redid.
        $(tbody).zebraRows();
      };
    }
  });
})(jQuery);
