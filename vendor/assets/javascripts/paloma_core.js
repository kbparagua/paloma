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
  
  callback(params);
};

Paloma._filters = {};

// Filter class
Paloma.Filter = function(name){
  this.name = name;
  this.type = undefined;
  this.actions = undefined;
  this.func = undefined;
  this.exception = false;  
};


// Generate filter methods
(function(){
  var Basic = function(type){
    return function(actions, func){
      this.type = type;
      this._setProperties(actions, func);
    };
  };
  
  
  var All = function(type){
    return function(func){
      this.type = type;
      this._setProperties('all', func);
    };
  };
  
  
  var Except = function(type){
    return function(actions, func){
      this.type = type;
      this.exception = true;
      this._setProperties(actions, func);
    };
  };


  var types = ['before', 'after', 'around'];
  for (var i = 0. n = types.length; i < n; i++){
    var type = types[i];
    Paloma.Filter.prototype[type] = new Basic(type);
    Paloma.Filter.prototype[type + '_all'] = new All(type);
    Paloma.Filter.prototype['except_' + type] = new Except(type);
  }
})();


Paloma.Filter.prototype._setProperties = function(actions, func){
  this.actions = actions;
  this.func = func;
};


// API
Paloma.filter = function(namespace_or_controller){
  Paloma._filters[namespace_or_controller] = new Paloma.Filter(namespace_or_controller);
  return Paloma._filters[namespace_or_controller];
};
