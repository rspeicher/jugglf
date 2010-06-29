if (typeof JuggLF === "undefined") {
  var JuggLF = {};
}

(function($)
{
  $.extend(JuggLF, {
    search: new function() {
      this.init = function() {
        // Add the 'Search...' text to the search field, and remove it when it's focused
        $('#main_search').addClass('inactive').val('Search...');
        $('#main_search').focus(function() {
          if ($(this).hasClass('inactive')) {
            $(this).removeClass('inactive').val('');
          }
        });

        $('#search_options').text($('#search_options_menucontent :checked').parent().text());

        // When a context is selected, change to that value, hide the menu and focus the search
        $('#search_options_menucontent :input').change(function() {
          $('#search_options').text($(this).parent().text());
          $('#search_options_menucontent').toggle();
          $('#main_search').focus();
        });

        // When #search_options is clicked, display #search_options_menucontent
        $('#search_options').click(function() {
          $('#search_options_menucontent').toggle();
        });
      };

      this.toggle = function() {
      };
    }
  });
})(jQuery);
