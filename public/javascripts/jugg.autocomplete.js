/**
 * Add an Item-specific autocompletion on a given field.
 */
function addItemAutoComplete(field) {
    $(field).autocomplete('/search/items.js', {
      minChars: 2,
      dataType: 'json',
      scrollHeight: 260,
      parse: function(data) {
          var array = new Array();
          for (var i = 0; i < data.length; i++) {
              if (data[i].item) {
                  var icon = ( data[i].item.icon ) ? data[i].item.icon.toLowerCase() : 'inv_misc_questionmark';
                  var formatted = "<img src='http://static.wowhead.com/images/icons/medium/" + icon + ".jpg'/>" + 
                    "<span class='" + data[i].item.color + "'>" + data[i].item.name + "</span>" + 
                    "<br/>" + data[i].item.level + " " + data[i].item.slot;
                    
                  array[array.length] = { 
                      data: data[i],
                      value: formatted,
                      result: data[i].item.wow_id
                  }
              };
          }
          return array;
      },
      formatItem: function(row, i, max, value) {
          return value;
      }
    });
}

/**
 * Add a Member-specific autocompletion on a given field.
 */
function addMemberAutoComplete(field) {
    $(field).autocomplete('/search/members.js', {
      minChars: 1,
      dataType: 'json',
      parse: function(data) {
          var array = new Array();
          for (var i = 0; i < data.length; i++) {
              if (data[i].member) {
                  array[array.length] = { 
                      data: data[i], 
                      value: data[i].member.name,
                      result: data[i].member.name
                  }
              };
          }
          return array;
      },
      formatItem: function(row, i, max, value) {
          return value;
      }
    });
}