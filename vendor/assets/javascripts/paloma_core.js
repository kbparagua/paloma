window.Paloma = {callbacks:{}};

// Execute callback that corresponds to the controller and action passed.
Paloma.execute = function(controller, action, params){
  
  var callbackFound = true;
  
  var callback = Paloma.callbacks[controller];
  if (callback === undefined || callback === null){ callbackFound = false; }
    
  callback = callback[action];
  if (callback === undefined || callback === null){ callbackFound = false; }

  
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
  
  
  // Start executions
  var beforeFilters = Paloma._getOrderedFilters('before', 
    params['callback_namespace'], controller, action);

  var afterFilters = Paloma._getOrderedFilters('after',
    params['callback_namespace'], controller, action);

  Paloma._performFilters(beforeFilters);
  if (callbackFound) { callback(params); }
  Paloma._performFilters(afterFilters);
};



Paloma._filters = {'before' : {}, 'after' : {}, 'around' : {}};


Paloma._getOrderedFilters = function(before_or_after, namespace, controller, action){
  var namespaceFilters = Paloma._filters[before_or_after][namespace], 
    controllerFilters = Paloma._filters[before_or_after][controller],
    filters = [];

  // Prepend namespace filters on controller filters.
  // Namespace filters must be executed first before controller filters.
  if (namespaceFilters !== undefined){
    // Around filters has lower precedence than before and after filters
    namspaceFilters = namespaceFilters.concat(Paloma._filters['around'][namespace] || []);
    namespaceFilters = namespaceFilters.concat(controllerFilters || []);
    controllerFilters = namespaceFilters;
  }

  if (controllerFilters !== undefined){
    controllerFilters = controllerFilters.concat(Paloma._filters['around'][namespace] || []);
    
    // Select applicable filters for the passed action
    for (var i = 0, n = controllerFilters.length; i < n; i++){
      var filter = controllerFilters[i];
      if (filter._isApplicable(action)){ filters.push(filter); }
    }
  }

  return filters.length == 0 ? undefined : filters;
};


Paloma._performFilters = function(filters, params){
  if (filters !== undefined){
    for (var i = 0, n = filters.length; i < n; i++){
      filters[i].method(params);
    }
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


// This will be the last method to be invoked when declaring a filter.
// This will set what method/function will be executed when the filter is called.
Paloma.Filter.prototype.perform = function(method){ 
  this.method = method;

  // This is the only time the filter is registered.
  Paloma._filters[this.type][this.scope] = Paloma._filters[this.type][this.scope] || [];
  Paloma._filters[this.type][this.scope].push(this);

  return this;
};


// Returns a boolean value indicating wether this filter is applicable
// on the passed action.
Paloma.Filter.prototype._isApplicable = function(action){
  var allActions = this.actions == 'all',
    isQualified = this.exception == false && this.actions.indexOf(action) != -1,
    isNotExcepted = this.exception == true && this.actions.indexOf(action) == -1;
  
  return (allActions || isQualified || isNotExcepted);
};


// Generate filter methods
(function(){
  var Basic = function(type){
    return function(){ return this._setProperties(type, arguments); };
  };

  var All = function(type){
    return function(){ return this._setProperties(type, 'all'); };
  };
  
  var Except = function(type){
    return function(){
      this.exception = true;
      return this._setProperties(type, arguments);
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


Paloma.Filter.prototype._setProperties = function(type, actions){
  // if all
  if (typeof actions === 'string'){ this.actions = actions; }
  // if arguments, convert to array
  else { this.actions = Array.prototype.slice.call(actions); }
  
  this.type = type;
  return this;
};
