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
    if (Paloma.Filter._isApplicable(filter, action){ filter.perform(params); }
  } 
};



// Filter class
Paloma.Filter = function(scope){
  this.scope = scope;
  this.name = undefined;
  this.type = undefined;
  this.actions = undefined;
  this.func = undefined;
  this.exception = false;  
};


Paloma.Filter._isApplicable = function(filter, action){  
  var allActions = filter.actions == 'all',
    isQualified = filter.exception == false && filter.actions.indexOf(action) != -1,
    isExcepted = filter.exception == true && filter.actions.indexOf(action) != -1;
    
  return (allActions || isQualified || !isExcepted);
};


Paloma.Filter.prototype.perform = function(params){
  return this.func(params);
};


// Generate filter methods
(function(){
  var Basic = function(type){
    return function(actions, name, func){
      this._setProperties(type, actions, name, func);
      this._addToFilters();
    };
  };

  var All = function(type){
    return function(name, func){
      this._setProperties(type, 'all', name, func);
      this._addToFilters();
    };
  };
  
  var Except = function(type){
    return function(actions, name, func){
      this.exception = true;
      this._setProperties(actions, name, func);
      this._addToFilters();
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



Paloma.Filter.prototype._addToFilters = function(){
  Paloma._filters[this.type][this.scope] = Paloma._filters[this.type][this.scope] || {};
  Paloma._filters[this.type][this.scope][this.name] = this;
};


Paloma.Filter.prototype._setProperties = function(type, actions, name, func){
  this.type = type;
  this.name = name;
  this.actions = actions;
  this.func = func;
};


// API
Paloma.filter = function(namespace_or_controller){
  return (new Paloma.Filter(namespace_or_controller));
};
