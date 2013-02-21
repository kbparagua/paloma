window.Paloma = {callbacks:{}};

// Execute callback that corresponds to the controller and action passed.
Paloma.execute = function(controller, action, params){
  
  // Stop execution if callback object for controller is not found.
  var callback = Paloma.callbacks[controller];
  if (callback === undefined || callback === null){ return false; }
    
  // Stop execution if a callback for action is not found.
  callback = callback[action];
  if (callback === undefined || callback === null){ return false; }

  
  // Parse parameters
  params = params || {};
  
  // Request details
  var requestControllerPath = params['controller_path'].split('/');
  params['controller'] = requestControllerPath.pop();
  params['namespace'] = requestControllerPath.join('/');
  
  // Callback details
  var callbackControllerPath = controller.split('/');
  params['callback_controller'] = callbackControllerPath.pop();
  params['callback_namespace'] = callbackControllerPath.join('/');
  params['callback_controller_path'] = controller;
  params['callback_action'] = action;
  
  
  // Filters
  
  // Start executions
  //Paloma._performFilters('before', params['callback_namespace'], action, params);
  Paloma._performFilters('before', controller, action, params);
  //if (namespaceFilter.around)   { namespaceFilter.around.perform(params); }
  //if (controllerFilter.before)  { controllerFilter.before.perform(params); }
  //if (controllerFilter.around)  { controllerFilter.around.perform(params); }
  callback(params);
  //if (namespaceFilter.after)    { namespaceFilter.after.perform(params); }
  //if (namespaceFilter.around)   { namespaceFilter.around.perform(params); }
  //if (controllerFilter.after)   { controllerFilter.after.perform(params); }
  ///if (controllerFilter.around)  { controllerFilter.around.perform(params); }
};



Paloma._filters = {'before' : {}, 'after' : {}, 'around' : {}};


Paloma._performFilters = function(type, namespace_or_controller_path, action, params){
  var filters = Paloma._filters[type][namespace_or_controller_path];
  if (filters === undefined){ return null; }    

  for (var filterName in filters){
    var filter = filters[filterName];
    if (Paloma.Filter._isApplicable(filter, action)){ filter.method(params); }
  } 
};



// FilterScope Class
Paloma.FilterScope = function(name){ this.name = name; };

Paloma.FilterScope.prototype.as = function(filterName){
  return (new Paloma.Filter(this.name, filterName));
};



// Filter class
Paloma.Filter = function(scope, name){
  this.scope = scope;
  this.name = name;
  this.type = undefined;
  this.actions = undefined;
  this.method = undefined;
  this.exception = false;  
};


// Mutators
Paloma.Filter.prototype.perform = function(method){ 
  this.method = method;
  this._addToFilters();
  return this;
};


// Generate filter methods
(function(){
  var Basic = function(type){
    return function(actions){ return this._setProperties(type, actions); };
  };

  var All = function(type){
    return function(){ return this._setProperties(type, 'all'); };
  };
  
  var Except = function(type){
    return function(actions){
      this.exception = true;
      return this._setProperties(type, actions);
    };
  };

  var types = ['before', 'after', 'around'];
  for (var i = 0, n = types.length; i < n; i++){
    var type = types[i];
    Paloma.Filter.prototype[type] = new Basic(type);
    Paloma.Filter.prototype[type + '_all'] = new All(type);
    Paloma.Filter.prototype['except_' + type] = new Except(type);
  }
})();



// Filter Helpers
Paloma.Filter._isApplicable = function(filter, action){  
  var allActions = filter.actions == 'all',
    isQualified = filter.exception == false && filter.actions.indexOf(action) != -1,
    isExcepted = filter.exception == true && filter.actions.indexOf(action) != -1;
    
  return (allActions || isQualified || !isExcepted);
};


Paloma.Filter.prototype._addToFilters = function(){
  Paloma._filters[this.type][this.scope] = Paloma._filters[this.type][this.scope] || {};
  Paloma._filters[this.type][this.scope][this.name] = this;
};


Paloma.Filter.prototype._setProperties = function(type, actions){
  this.type = type;
  this.actions = actions;
  return this;
};
