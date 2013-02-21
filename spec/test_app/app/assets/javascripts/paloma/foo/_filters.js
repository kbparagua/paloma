(function(){ var filter = new Paloma.FilterScope('foo');
  
  filter.as('filter A').
  before('basic action', 'callback_from_another_action').
  perform(function(params)
  {
    window.beforeFilter = 'foo/basic_action';
    window.filterChain = 'A';  
    
    console.log('Filter A');
    console.log('filter chain = ' + filterChain);
  }); 
  
  
  filter.as('filter B').
  before_all().perform(function(params)
  {
    window.beforeFilter = 'foo/all';
    window.filterChain = filterChain + '/B';
    
    console.log('Filter B');
    console.log('filter chain = ' + filterChain);
  });
  
  
  filter.as('filter C').
  except_before('callback_from_another_action').
  perform(function(params)
  {
    window.beforeFilter = 'foo/except callback_from_another_action';
    window.filterChain = filterChain + '/C';
  
    console.log('Filter C');
    console.log('filter chain = ' + filterChain);
  });
  
  
})();
