(function(Paloma){

  Paloma._controllerClassFactory = new Paloma.ControllerClassFactory();
  Paloma.engine = new Paloma.Engine({builder: Paloma._controllerBuilder});

  Paloma.controller = function(name, prototype){
    return Paloma._controllerClassFactory.make(name, prototype);
  };

  Paloma._executeHook = function(){
    var hook = document.querySelector('.js-paloma-hook script');
    if (hook) eval(hook.innerHTML);
  };

  Paloma.start = function(){
    if ( !this.engine.hasRequest() ) this._executeHook();
    if ( this.engine.hasRequest() ) this.engine.start();
  };

  Paloma.isExecuted = function(){
    return this.engine.lastRequest().executed;
  };

})(window.Paloma);
