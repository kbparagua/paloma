// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ var filter = new Paloma.FilterScope('sample_namespace');
  
  // To-Be-Skipped Before Filters
  filter.as('All - Skip This Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('All - Skip This Before Filter');
  });
  
  filter.as('Only - Skip This Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Only - Skip This Before Filter');
  });

  filter.as('Except - Skip This Before Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Except - Skip This Before Filter');
  });


  // To-Be-Skipped After Filters
  filter.as('All - Skip This After Filter').before_all().perform(function(params){
    filtersExecuted.before.push('All - Skip This After Filter');
  });
  
  filter.as('Only - Skip This After Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Only - Skip This After Filter');
  });

  filter.as('Except - Skip This After Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Except - Skip This After Filter');
  });


  // To-Be-Skipped Around Filters
  filter.as('All - Skip This Around Filter').before_all().perform(function(params){
    filtersExecuted.before.push('All - Skip This Around Filter');
  });
  
  filter.as('Only - Skip This Around Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Only - Skip This Around Filter');
  });

  filter.as('Except - Skip This Around Filter').before_all().perform(function(params){
    filtersExecuted.before.push('Except - Skip This Around Filter');
  });

  // Before
  filter.as('Namespaced Standard Before').
  before('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Standard Before');
  }); 
  
  
  filter.as('Namespaced Before All').
  before_all().perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Before All');
  });
  
  
  filter.as('Namespaced Except Before').
  except_before('basic_action').
  perform(function(params)
  {
    filtersExecuted.before.push('Namespaced Except Before');
  });
  
  
  // After
  filter.as('Namespaced Standard After').
  after('basic_action', 'another_basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Namespaced Standard After');
  });
  
  
  filter.as('Namespaced After All').
  after_all().perform(function(params)
  {
    filtersExecuted.after.push('Namespaced After All');
  });
  
  
  filter.as('Namespaced Except After').
  except_after('basic_action').
  perform(function(params)
  {
    filtersExecuted.after.push('Namespaced Except After');
  });
  
  
  // Around
  filter.as('Namespaced Standard Around').
  around('basic_action', 'another_basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Standard Around');
  });
  
  
  filter.as('Namespaced Around All').
  around_all().perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Around All');
  });
  
  
  filter.as('Namespaced Except Around').
  except_around('basic_action').
  perform(function(params)
  {
    var execution = window.callback ? 'after' : 'before';
    filtersExecuted[execution].push('Namespaced Except Around');
  });
  
})();
