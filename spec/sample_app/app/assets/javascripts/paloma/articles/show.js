Paloma.callbacks['articles/show'] = function(params){
  $('body').append($("<div id='from-articles-show-callback'></div>"));

  
  if (params['controller'] === 'articles' && params['action'] === 'show'){
    $('body').append($("<div id='controller-and-action-received'></div>"));
  }
};
