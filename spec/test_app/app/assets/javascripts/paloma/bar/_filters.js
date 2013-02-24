// For testing only
window.filtersExecuted = [];

(function(){ var filter = new Paloma.FilterScope('bar');
  
  // Before
  filter.as('Standard Before').
  before('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.push('Standard Before');
  }); 
  
  
  filter.as('Before All').
  before_all().perform(function(params)
  {
    filtersExecuted.push('Before All');
  });
  
  
  filter.as('Except Before').
  except_before('basic_action').
  perform(function(params)
  {
    filtersExecuted.push('Except Before');
  });
  
  
  // After
  filter.as('Standard After').
  after('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.push('Standard After');
  });
  
  
  filter.as('After All').
  after_all().perform(function(params)
  {
    filtersExecuted.push('After All');
  });
  
  
  filter.as('Except After').
  except_after('basic_action').
  perform(function(params)
  {
    filtersExecuted.push('Except After');
  });
  
})();
