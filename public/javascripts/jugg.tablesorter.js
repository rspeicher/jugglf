if (typeof JuggLF === "undefined") {
  var JuggLF = {};
}

// ----------------------------------------------------------------------------
// Custom tablesorter parsers
// ----------------------------------------------------------------------------

// Custom sorter to sort wishlist priorities as Best in Slot > Normal > Rot > Situational
$.tablesorter.addParser({
    id: 'wishlist',
    is: function(s) {
        return false;
    },
    format: function(s) {
        return s.toLowerCase().replace(/best in slot/, 1).replace(/normal/, 2).replace(/rot/, 3).replace(/situational/, 4);
    },
    type: 'numeric'
});

// Sort a field by its text while ignoring its <a> tag.
$.tablesorter.addParser({
    id: 'without-link',
    is: function(s) {
        return false;
    },
    format: function(s) {
        return s.replace(/.*<a.+>(.+)<\/a>.*/, '$1');
    },
    type: 'text'
});

// ----------------------------------------------------------------------------
// Core functions
// ----------------------------------------------------------------------------

(function($)
{
    /**
     * Re-applies alternating row colors to the specified element.
     *
     * Options:
     *  delay: Apply alternating colors after a specified delay.
     *  row1Class: CSS class to use for odd rows.
     *  row2Class: CSS class to use for even rows.
     *
     * Examples:
     *  $('tbody#wishlist').zebraRows();
     *  $('tbody#wishlist').zebraRows({delay: 1000, row1Class: 'rowA', row2Class: 'rowB'});
     */
    $.fn.zebraRows = function(options)
    {
        var settings = jQuery.extend({
          delay: 0,
          row1Class: 'row1',
          row2Class: 'row2'
        }, options);

        var table = this;

        setTimeout(function() {
            background = settings.row1Class;
            $(table).children('tr:visible').each(function() {
                $(this).removeClass(settings.row1Class);
                $(this).removeClass(settings.row2Class);
                $(this).addClass(background);
                background = (background == settings.row1Class) ? settings.row2Class: settings.row1Class;
            });
        }, settings.delay);
    }
})(jQuery);

// ----------------------------------------------------------------------------
// JuggLF extensions
// ----------------------------------------------------------------------------

(function($) {
  $.extend(JuggLF, {
    tablesorter: new function() {
      // Private
      var defaults = {
        widgets: ['zebra']
      };

      /**
       * Sort a table of Items
       *
       * Assumes that the table has both a +tablesorter+ and +as_items+ class.
       */
      function as_items() {
        if ($('table.tablesorter.as_items tbody tr').length > 1) {
          $('table.tablesorter.as_items').tablesorter($.extend({
            sortList: [[0,1]],
            headers: {
              0: { sorter: 'without-link' }, // Date
              1: { sorter: 'without-link' }, // Name
              2: { sorter: 'wishlist'     }, // Note
              3: { sorter: 'currency'     }  // Price
            }
          }, defaults));
        }
      }

      /**
       * Sort a table of Members
       *
       * Assumes that the table has both a +tablesorter+ and +as_members+ class.
       */
      function as_members() {
        if ($('table.tablesorter.as_members tbody tr').length > 1) {
          $('table.tablesorter.as_members').tablesorter($.extend({
            sortList: [[1,0]],
            headers: {
              1: { sorter: 'without-link' }, // Name
              6: { sorter: 'currency'     }, // Loot Factor
              7: { sorter: 'currency'     }, // BiS
              8: { sorter: 'currency'     }  // Sit
            }
          }, defaults));
        }
      }

      /**
       * Sort a table of a Member's Wishlist entries
       *
       * Assumes that the table has both a +tablesorter+ and +as_member_wishlist+ class.
       */
      function as_member_wishlist() {
        if ($('table.tablesorter.as_member_wishlist tbody tr').length > 1) {
          $('table.tablesorter.as_member_wishlist').tablesorter($.extend({
            sortList: [[2,0], [1,0]],        // Sort Priority then Name
            headers: {
              0: { sorter: false          }, // Don't sort the item icon
              1: { sorter: 'without-link' }, // Sort by item name without the link
              2: { sorter: 'wishlist'     }, // Priority
              5: { sorter: false          }  // Don't sort the 'Delete' icon
            }
          }, defaults));
        }
      }

      /**
       * Sort a table of Wishlist entries
       *
       * Assumes that the table has both a +tablesorter+ and +as_wishlist+ class.
       */
      function as_wishlist() {
        $('table.tablesorter.as_wishlist').each(function() {
          if ($(this).children('tbody').children('tr').length > 1) {
            $(this).tablesorter($.extend({
              sortList: [[1,0], [2,0]],    // Priority then LF
              headers: {
                1: { sorter: 'wishlist' }, // Priority
                2: { sorter: 'currency' }  // LF
              }
            }, defaults));
          }
        });
      }

      // Public
      this.init = function() {
        as_items();
        as_members();
        as_member_wishlist();
        as_wishlist();
      };
    }
  });
})(jQuery);
