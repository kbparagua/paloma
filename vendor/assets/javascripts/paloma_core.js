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
  var controller_full_path = controller.split('/');
  params['callback_controller'] = controller_full_path.pop();
  params['callback_namespace'] = controller_full_path.join('/');
  params['callback_controller_path'] = controller;
  params['callback_action'] = action;
  
  callback(params);
};
