Paloma.callbacks['sample_namespace/categories/index'] = function(params){
  $('body').append($("<div id='from-categories-index'></div>"));

  
  if (params['controller'] === 'sample_namespace/categories' &&
    params['action'] === 'index'){
  
    $('body').append($("<div id='controller-with-namespace-and-action-received'></div>"));  
  }
};
