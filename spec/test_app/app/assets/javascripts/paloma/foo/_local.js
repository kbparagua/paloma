(function(){
Paloma.callbacks['foo'] = {};
Paloma.locals['foo'] = {};
locals = Paloma.locals['foo'];

// Locals starts here
locals.helperMethod = function(){
  return 100;
};

locals.helperVariable = 99;


locals.toBeOverriden = function(){
  return "Override!"
};


// Locals ends here
Paloma.inheritLocals({from : '/', to : 'foo'});
})();
