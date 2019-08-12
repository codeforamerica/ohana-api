var main = (function () {
"use strict";

  var NUM_LEVELS = 2;

  // initalize the application
  function init()
  {
    var checkboxes = $('#categories input');

    var currentCheckbox;
    for (var i=0; i < checkboxes.length; i++)
    {
      currentCheckbox = checkboxes[i];
      _checkState('depth',0,currentCheckbox);
    }

    var lnks = $('#categories input');

    var curr;
    for (var l=0; l < lnks.length; l++)
    {
      curr = lnks[l];
      $(curr).click(_linkClickedHandler)
    }
  }

  function _linkClickedHandler(evt)
  {
    var el = evt.target;
    if (el.nodeName == 'INPUT')
    {
      _checkState('depth',0,el);
    }

  }

  function _checkState(prefix,depth,checkbox)
  {
    var item = $(checkbox).parent(); // parent li item
    var id = prefix+String(depth);
    while(!item.hasClass(id))
    {
      depth++;
      id = prefix+String(depth);
    }

    id = 'li.'+prefix+String(depth+1);
    var lnks = $(id,item);
    var curr;
    for (var l=0; l < lnks.length; l++)
    {
      curr = lnks[l];
      if (checkbox.checked)
      {
        $(curr).removeClass('hide');
      }
      else
      {
        $(curr).addClass('hide');
        checkbox = $('input',$(curr))
        checkbox.prop('checked', false);
        _checkState(prefix,depth,checkbox)
      }
    }

  }

  // return internally scoped var as value of globally scoped object
  return {
    init:init
  };

})();

$(document).ready(function(){
  main.init();
});
