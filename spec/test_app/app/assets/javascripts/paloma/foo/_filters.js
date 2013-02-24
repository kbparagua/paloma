(function(){ var filter = new Paloma.FilterScope('foo');
  
  filter.as('A').
  before('callback_from_another_action', 'basic_action').
  perform(function(params)
  {
    window.filterChain = 'A';  
  }); 
  
  
  filter.as('B').
  before_all().perform(function(params)
  {
    window.filterChain = filterChain + '/B';
  });
  
  
  filter.as('C').
  except_before('callback_from_another_action').
  perform(function(params)
  {
    window.filterChain = filterChain + '/C';
  });
  
  
})();
