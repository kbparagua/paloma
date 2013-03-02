(function(){
Paloma.locals['/'] = {};
locals = Paloma.locals['/'];

// Locals starts here
locals.applicationHelperMethod = function(){
  return "I'm from application locals!"
};


locals.toBeOverriden = function(){
  return "Override me!"
};


// Locals ends here
})();
