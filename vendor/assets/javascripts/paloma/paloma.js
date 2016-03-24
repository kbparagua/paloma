(function(Paloma){

  var classFactory = new Paloma.ControllerClassFactory(),
      controllerBuilder = new Paloma.ControllerBuilder(classFactory),
      engine = new Paloma.Engine(controllerBuilder)

  Paloma._controllerClassFactory = classFactory;
  Paloma._controllerBuilder = controllerBuilder
  Paloma.engine = engine;

  Paloma.controller = function(name, prototype){
    return classFactory.make(name, prototype);
  };

  Paloma._executeHook = function(){
    var hook = document.querySelector('.js-paloma-hook script');
    if (hook) eval(hook.innerHTML);
  };

  Paloma.start = function(){
    if ( !engine.hasRequest() ) this._executeHook();
    if ( engine.hasRequest() ) engine.start();
  };

  Paloma.isExecuted = function(){
    return engine.lastRequest().executed;
  };

})(window.Paloma);
