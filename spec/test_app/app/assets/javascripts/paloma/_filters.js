// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ var filter = new Paloma.FilterScope('/');
  
  // To-Be-Skipped Before Filters
  filter.as('Standard Skip Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Standard Skip Before Filter');
  });
  
  filter.as('Only Skip Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Only Skip Before Filter');
  });

  filter.as('Except Skip Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Except Skip Before Filter');
  });


  // To-Be-Skipped After Filters
  filter.as('Standard Skip After Filter').after_all().perform(function(params){
    filtersExecuted.after.push('Standard Skip After Filter');
  });
  
  filter.as('Only Skip After Filter').after_all().perform(function(params){
    filtersExecuted.after.push('Only Skip After Filter');
  });

  filter.as('Except Skip After Filter').after_all().perform(function(params){
    filtersExecuted.after.push('Except Skip After Filter');
  });


  // To-Be-Skipped Around Filters
  filter.as('Standard Skip Around Filter').around_all().perform(function(params){
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Standard Skip Around Filter');
  });
  
  filter.as('Only Skip Around Filter').around_all().perform(function(params){
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Only Skip Around Filter');
  });

  filter.as('Except Skip Around Filter').around_all().perform(function(params){
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Except Skip Around Filter');
  });



  // Before
  filter.as('Application Standard Before').
  before('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Application Standard Before');
  });
  
  
  filter.as('Application Before All').
  before_all().perform(function(params)
  {
    filtersExecuted.before.push('Application Before All');
  });
  
  
  filter.as('Application Except Before').
  except_before('basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Application Except Before');
  });
  
  
  // After
  filter.as('Application Standard After').
  after('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Application Standard After');
  });
  
  
  filter.as('Application After All').
  after_all().perform(function(params)
  {
    filtersExecuted.after.push('Application After All');
  });
  
  
  filter.as('Application Except After').
  except_after('basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Application Except After');
  });
  
  
  // Around
  filter.as('Application Standard Around').
  around('basic_action', 'another_basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Application Standard Around');
  });
  
  
  filter.as('Application Around All').
  around_all().perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Application Around All');
  });
  
  
  filter.as('Application Except Around').
  except_around('basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Application Except Around');
  });
  
})();
