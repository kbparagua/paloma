// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ 
  var filter = new Paloma.FilterScope('bar');
  var _x = Paloma.variableContainer;


  filter.skip_before_filter('Standard Skip Before Filter');
  filter.skip_before_filter('Only Skip Before Filter').only('basic_action');
  filter.skip_before_filter('Except Skip Before Filter').except('yet_another_basic_action');

  filter.skip_after_filter('Standard Skip After Filter');
  filter.skip_after_filter('Only Skip After Filter').only('basic_action');
  filter.skip_after_filter('Except Skip After Filter').except('yet_another_basic_action');

  filter.skip_around_filter('Standard Skip Around Filter');
  filter.skip_around_filter('Only Skip Around Filter').only('basic_action');
  filter.skip_around_filter('Except Skip Around Filter').except('yet_another_basic_action');
  

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
