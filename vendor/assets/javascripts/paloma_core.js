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
  this.only = undefined;
  this.func = undefined;
};


Paloma.Filter.prototype.before = function(only, func){
  this.type = 'before';
  this._setProperties(only, func);
};


Paloma.Filter.prototype.after = function(only, func){
  this.type = 'after';
  this._setProperty(only, func);
};


Paloma.Filter.prototype.around = function(only, func){
  this.type = 'around';
  this._setProperty(only, func);
};


var types = ['before', 'after', 'around'];
for (var i = 0, n = types.length; i < n; i++)}{
  var type = types[i];
  Paloma.Filter.prototype[type + '_all'] = function(){};
  Paloma.Filter.prototype['except_' + type] = function(){}; 
}


Paloma.Filter.prototype._setProperties = function(only, func){
  this.only = only;
  this.func = func;
};


// API
Paloma.filter = function(namespace_or_controller){
  Paloma._filters[namespace_or_controller] = new Paloma.Filter(namespace_or_controller);
  return Paloma._filters[namespace_or_controller];
};
