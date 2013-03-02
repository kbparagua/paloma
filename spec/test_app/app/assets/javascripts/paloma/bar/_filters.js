// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ var filter = new Paloma.FilterScope('bar');
  
  // Before
  filter.as('Standard Before').
  before('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Standard Before');
  });
  
  
  filter.as('Before All').
  before_all().perform(function(params)
  {
    filtersExecuted.before.push('Before All');
  });
  
  
  filter.as('Except Before').
  except_before('basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Except Before');
  });
  
  
  // After
  filter.as('Standard After').
  after('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Standard After');
  });
  
  
  filter.as('After All').
  after_all().perform(function(params)
  {
    filtersExecuted.after.push('After All');
  });
  
  
  filter.as('Except After').
  except_after('basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Except After');
  });
  
  
  // Around
  filter.as('Standard Around').
  around('basic_action', 'another_basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Standard Around');
  });
  
  
  filter.as('Around All').
  around_all().perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Around All');
  });
  
  
  filter.as('Except Around').
  except_around('basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Except Around');
  });
  
})();
