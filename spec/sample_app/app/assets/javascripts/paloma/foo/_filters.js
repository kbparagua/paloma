Paloma.filter('foo').before(['basic_action'], 'filter A', function(params){
  window.beforeFilter = 'foo/basic_action';
  window.filterChain = 'A';
});


//Paloma.filter('foo').before_all('filter B', function(params){
  //window.filterChain = filterChain + '/B'
//});
