(function(){
window.Paloma = {
  callbacks : {},
  filterScopes : {},
  variableContainer : {}
};


var FILTER_TYPES = {},
  FILTER_TYPE_NAMES = ['BEFORE', 'AFTER', 'AROUND'],
  INCLUSION_TYPES = {},
  INCLUSION_TYPE_NAMES = ['ALL', 'ONLY', 'EXCEPT'];

FILTER_TYPES.BEFORE = 0;
FILTER_TYPES.AFTER = 1;
FILTER_TYPES.AROUND = 2;

INCLUSION_TYPES.ALL = 3;
INCLUSION_TYPES.ONLY = 4;
INCLUSION_TYPES.EXCEPT = 5;
  


Paloma.FilterScope = function(name){ 
  this.name = name;
  
  this.filters = {};
  this.skippers = {};

  for (var i = 0, n = FILTER_TYPE_NAMES.length; i < n; i++){
    var type = FILTER_TYPE_NAMES[i].toUpperCase();
    this.filters[ FILTER_TYPES[type] ] = [];
    this.skippers[ FILTER_TYPES[type] ] = [];
  }

  Paloma.filterScopes[name] = this;
};


// Creates a new Filter instance registered under this FilterScope.
Paloma.FilterScope.prototype.as = function(filterName){
  return (new Paloma.Filter(this, filterName));
};


// skip_*_filter/s methods
(function(){
  for (var i = 0, n = FILTER_TYPE_NAMES.length; i < n; i++){
    var type = FILTER_TYPE_NAMES[i],
      singular = 'skip_' + type.toLowerCase() + '_filter',
      plural = singular + 's',
      method = function(skipperType){ 
        return function(){
          return (new Paloma.Skipper(this, FILTER_TYPES[skipperType], arguments));
        };
      };

    Paloma.FilterScope.prototype[singular] = new method(type);
    Paloma.FilterScope.prototype[plural] = Paloma.FilterScope.prototype[singular];
  }
})();




// Skipper class
Paloma.Skipper = function(scope, type, filters){
  this.scope = scope;
  this.type = type;
  this.filters = Array.prototype.slice.call(filters);
  this.inclusionType = INCLUSION_TYPES.ALL;
  this.actions = [];

  // Register this skipper on its scope.
  this.scope.skippers[this.type].push(this);
};


Paloma.Skipper.prototype.skip = function(filter, action){
  if (this.filters.indexOf(filter.name) == -1){ return false; }

  var actionIsListed = this.actions.indexOf(action) != -1, 
    isAllActions = this.inclusionType == INCLUSION_TYPES.ALL,
    isQualified = this.inclusionType == INCLUSION_TYPES.ONLY && actionIsListed,
    isNotExcepted = this.inclusionType == INCLUSION_TYPES.EXCEPT && !actionIsListed;

  return (isAllActions || isQualified || isNotExcepted); 
};


Paloma.Skipper.prototype.only = function(){
  this.inclusionType = INCLUSION_TYPES.ONLY;
  this.actions = Array.prototype.slice.call(arguments);
};


Paloma.Skipper.prototype.except = function(){ 
  this.inclusionType = INCLUSION_TYPES.EXCEPT;
  this.actions = Array.prototype.slice.call(arguments);
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
(function(){
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

for (var i = 0, n = FILTER_TYPE_NAMES.length; i < n; i++){
  var name = FILTER_TYPE_NAMES[i].toLowerCase(),
    type = FILTER_TYPES[name.toUpperCase()];

  Paloma.Filter.prototype[name] = new Basic(type);
  Paloma.Filter.prototype[name + '_all'] = new All(type);
  Paloma.Filter.prototype['except_' + name] = new Except(type);
}
})();
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
  var actionIsListed = this.actions.indexOf(action) != -1, 
    isAllActions = this.inclusionType == INCLUSION_TYPES.ALL,
    isQualified = this.inclusionType == INCLUSION_TYPES.ONLY && actionIsListed,
    isNotExcepted = this.inclusionType == INCLUSION_TYPES.EXCEPT && !actionIsListed;

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
  callbackFound = callback != undefined;
  
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
    FILTER_TYPES.AFTER,
    params['callback_namespace'],
    controller,
    action);

  // Start filter and callback executions
  performFilters(beforeFilters);
  if (callbackFound){ callback(params); }
  performFilters(afterFilters);

  // variableContainer is used to share variable between filters and callbacks.
  // It will be cleared after it is used.
  Paloma.variableContainer = [];
};


var getOrderedFilters = function(beforeOrAfter, namespace, controller, action){
  var filters = [],
    applicableFilters = [],
    skippers = [],
    scopes = [
      Paloma.filterScopes['/'], 
      Paloma.filterScopes[namespace], 
      Paloma.filterScopes[controller]];
  
  for (var i = 0, n = scopes.length; i < n; i++){
    var scope = scopes[i];
    if (scope == undefined){ continue; }

    var mainFilters = scope.filters[beforeOrAfter],
      aroundFilters = scope.filters[FILTER_TYPES.AROUND];
    
    // Around Filters have lower precedence than before or after filters.
    if (mainFilters != undefined){ filters = filters.concat(mainFilters); }
    if (aroundFilters != undefined){ filters = filters.concat(aroundFilters); }
    
    skippers = skippers.concat(
        scope.skippers[beforeOrAfter], 
        scope.skippers[FILTER_TYPES.AROUND]);
  }


  // Select only applicable filters for the passed action.
  for (var i = 0, n = filters.length; i < n; i++){
    var filter = filters[i],
      isApplicable = filter.isApplicable(action),
      isNotSkipped = true;

    for (var k = 0, len = skippers.length; k < len; k++){
      if ( skippers[k].skip(filter, action) ){ isNotSkipped = false; break;}
    }

    if (isApplicable && isNotSkipped){ applicableFilters.push(filter); } 
  }

  return applicableFilters;
};


var performFilters = function(filters, params){
  for (var i = 0, n = filters.length; i < n; i++){
    filters[i].method(params);
  }
};


})();