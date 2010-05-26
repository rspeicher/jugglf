if (typeof JuggLF === "undefined") {
  var JuggLF = {};
}

JuggLF.logger = {
  debug: function(message) {
    console.debug(message);
  }
};

$(document).ready(function() {
    // Make success messages clickable to hide them
    $('div.message.success').click(function() {
      $(this).fadeOut('slow');
    });

    JuggLF.itemFilter.init();
    JuggLF.moderation.init();
    JuggLF.tablesorter.init();

    // Add tooltips to '.help' objects
    $('.help').tooltip({ showURL: false });

    $("#ajax_loading").bind("ajaxSend", function() {
      $(this).show();
    }).bind("ajaxComplete", function() {
      $(this).hide();
    }).bind("ajaxSuccess", function() {
      // Call these again so we apply them for any pages that were loaded via AJAX.
      JuggLF.itemFilter.init();
      JuggLF.moderation.init();
      // JuggLF.tablesorter.init(); // FIXME: Causes unwanted behavior with wishlist form (duplicate rows)
    });
});
