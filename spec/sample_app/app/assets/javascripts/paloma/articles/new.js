Paloma.callbacks['articles']['new'] = function(params)
{
  $('body').append($("<div id='from-articles-new-callback'></div>"));
  
  if (params.callback_controller == 'articles' && params.callback_action == 'new'){
    $('body').append($("<div id='callback-details-received'></div>"));
  }
};
