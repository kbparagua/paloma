Paloma.filter('foo').before(['basic_action'], function(params){
  window.beforeFilter = 'foo/basic_action';
});
