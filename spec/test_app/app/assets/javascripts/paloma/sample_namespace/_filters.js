// For testing only
window.filtersExecuted = window.filtersExecuted || {before : [], after : []};


(function(){ var filter = new Paloma.FilterScope('sample_namespace');
  
  // To-Be-Skipped Filters
  var types = ['Before', 'After', 'Around'];
  for (var i = 0, n = types.length; i < n; i++){
    var skipTypes = ['All', 'Only', 'Except'];
    for (var j = 0, len = skipTypes.length; j < len; j++){
      var name = skipTypes[j] + ' - Skip This ' + types[i] +' Filter';

      filter.as(name).
      before_all().perform(function(params){
        filtersExecuted.before.push(name);
      });  
    }
  }
  


  filter.as('Skip This After Filter').
  after_all().perform(function(params){
    filtersExecuted.before.push('Skip This Filter Please');
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
