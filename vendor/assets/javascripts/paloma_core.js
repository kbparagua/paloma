(function(){
window.Paloma = {callbacks:{}};
Paloma.filterScopes = {};

var FILTER_TYPES = {},
  FILTER_TYPES.BEFORE = 0,
  FILTER_TYPES.AFTER = 1,
  FILTER_TYPES.AROUND = 2,
  FILTER_TYPE_NAMES = ['BEFORE', 'AFTER', 'AROUND'],
  INCLUSION_TYPES = {},
  INCLUSION_TYPES.ALL = 3,
  INCLUSION_TYPES.ONLY = 4,
  INCLUSION_TYPES.EXCEPT = 5,
  INCLUSION_TYPE_NAMES = ['ALL', 'ONLY', 'EXCEPT'];


Paloma.FilterScope = function(name){ 
  this.name = name;
  
  this.filters = {};
  this.filters[FILTER_TYPES.BEFORE] = [];
  this.filters[FILTER_TYPES.AFTER] = [];
  this.filters[FILTER_TYPES.AROUND] = [];

  this.skipFilters = [];
  this.skipFilterType = undefined;
  this.skipType = INCLUSION_TYPES.ALL;

  Paloma.filterScopes[name] = this;
};


// Creates a new Filter instance registered under this FilterScope.
Paloma.FilterScope.prototype.as = function(filterName){
  return (new Paloma.Filter(this, filterName));
};


// skip_*_filter methods
(function(){
  for (var i = 0, n = FILTER_TYPE_NAMES.length; i < n; i++){
    var type = types[i],
      method = 'skip_' + type.toLowerCase() + '_filter';

    Paloma.FilterScope.prototype[method] = function(){
      this.skipFilterType = FILTER_TYPES[type];
      this.skipFilters = Array.prototype.slice.call(arguments);
      return this;
    };
  }
})();

Paloma.FilterScope.prototype.only = function(){ 
  this.skipType = INCLUSION_TYPES.ONLY; 
};

Paloma.FilterScope.prototype.except = function(){ 
  this.skipType = INCLUSION_TYPES.EXCEPT; 
};



// Filter class
Paloma.Filter = function(scope, name){
  this.scope = scope;
  this.name = name;

  this.type = undefined;
  this.inclusionType = INCLUSION_TYPES.ONLY;

  this.actions = [];
  this.method = undefined;
};


// Create Methods:
//  - before, after, around, *_all, except_*
var Basic = function(type){ 
  return function(){ 
    return this.setProperties(type, INCLUSION_TYPES.ONLY, arguments); 
  };
};

var All = function(type){
  return function(){ 
    return this.setProperties(type, INCLUSION_TYPES.ALL, []);
  };
};

var Except = function(type){
  return function(){
    return this.setProperties(type, INCLUSION_TYPES.EXCEPT, arguments);
  };
};

for (var i = 0, n = FILTER_TYPES.length; i < n; i++){
  var type = types[i].toLowerCase();
  Paloma.Filter.prototype[type] = new Basic(type);
  Paloma.Filter.prototype[type + '_all'] = new All(type);
  Paloma.Filter.prototype['except_' + type] = new Except(type);
}
// End of creating methods.


// This will be the last method to be invoked when declaring a filter.
// This will set what method/function will be executed when the filter is called.
Paloma.Filter.prototype.perform = function(method){ 
  this.method = method;

  // This is the only time the filter is registered to its owner scope.  
  this.scope.filters[this.type].push(this);
  return this;
};


Paloma.Filter.prototype.isApplicable = function(action){
  var isAllActions = this.type == FILTER_TYPES.ALL, 
    isQualified = this.type == FILTER_TYPES.ONLY && this.actions.indexOf(action) != -1,
    isNotExcepted = this.type == FILTER_TYPES.EXCEPT && this.actions.indexOf(action) == -1;
  
  return (isAllActions || isQualified || isNotExcepted);
};


Paloma.Filter.prototype.setProperties = function(type, inclusion, actions){
  this.type = type;
  this.inclusionType = inclusion;
  this.actions = Array.prototype.slice.call(actions);
  return this;
};




// Execute callback that corresponds to the controller and action passed.
Paloma.execute = function(controller, action, params){
  var callbackFound = true;
  
  var callback = Paloma.callbacks[controller];
  callbackFound = callback != undefined);
  
  callback = callback[action];
  callbackFound = callback != undefined;
  
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
  

  var beforeFilters = getOrderedFilters(
    FILTER_TYPES.BEFORE, 
    params['callback_namespace'], 
    controller, 
    action);

  var afterFilters = getOrderedFilters(
    FITLER_TYPES.AFTER,
    params['callback_namespace'],
    controller,
    action);

  // Start filter and callback executions
  performFilters(beforeFilters);
  if (callbackFound){ callback(params); }
  performFilters(afterFilters);
};


var getOrderedFilters = function(before_or_after, namespace, controller, action){
  var namespaceFilters = Paloma.filterScopes[namespace],
    controllerFilters = Paloma._filters[before_or_after][controller],
    filters = [];

  // Prepend namespace filters on controller filters.
  // Namespace filters must be executed first before controller filters.
  if (namespaceFilters !== undefined){
    // Around filters has lower precedence than before and after filters
    namespaceFilters = namespaceFilters.concat(Paloma._filters['around'][namespace] || []);
    namespaceFilters = namespaceFilters.concat(controllerFilters || []);
    controllerFilters = namespaceFilters;
  }

  if (controllerFilters !== undefined){
    controllerFilters = controllerFilters.concat(Paloma._filters['around'][controller] || []);

    // Select applicable filters for the passed action
    for (var i = 0, n = controllerFilters.length; i < n; i++){
      var filter = controllerFilters[i];
      if (filter._isApplicable(action)){ filters.push(filter); }
    }
  }

  return filters;
};


var performFilters = function(filters, params){
  for (var i = 0, n = filters.length; i < n; i++){
    filters[i].method(params);
  }
};


})();