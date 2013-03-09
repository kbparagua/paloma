(function(){
  // Initializes callbacks container for the this specific scope.
  Paloma.callbacks['existing_namespace/new_controller'] = {};

  // Initializes locals container for this specific scope.
  // Define a local by adding property to 'locals'.
  //
  // Example:
  // locals.localMethod = function(){};
  var locals = Paloma.locals['existing_namespace/new_controller'] = {};

  
  // ~> Start local definitions here and remove this line.


  // Remove this line if you don't want to inherit locals defined
  // on parent's _locals.js
  Paloma.inheritLocals({from : 'existing_namespace', to : 'existing_namespace/new_controller'});
})();