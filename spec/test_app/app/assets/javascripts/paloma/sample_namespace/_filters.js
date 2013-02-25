// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ var filter = new Paloma.FilterScope('sample_namespace');
  
  // Before
  filter.as('Standard Before').
  before('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Standard Before');
  }); 
  
  
  filter.as('Before All').
  before_all().perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Before All');
  });
  
  
  filter.as('Except Before').
  except_before('basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Except Before');
  });
  
  
  // After
  filter.as('Standard After').
  after('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Namespaced Standard After');
  });
  
  
  filter.as('After All').
  after_all().perform(function(params)
  {
    filtersExecuted.after.push('Namespaced After All');
  });
  
  
  filter.as('Except After').
  except_after('basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Namespaced Except After');
  });
  
  
  // Around
  filter.as('Standard Around').
  around('basic_action', 'another_basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Standard Around');
  });
  
  
  filter.as('Around All').
  around_all().perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Around All');
  });
  
  
  filter.as('Except Around').
  except_around('basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Except Around');
  });
  
})();
