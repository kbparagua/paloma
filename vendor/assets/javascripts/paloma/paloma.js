(function(Paloma){

  Paloma._controllerBuilder = new Paloma.ControllerBuilder();
  Paloma.engine = new Paloma.Engine({builder: Paloma._controllerBuilder});

  Paloma.baseController = function(prototype){
    return Paloma.BaseController.prototype
  };

  Paloma.controller = function(name, prototype){
    return Paloma._controllerBuilder.build(name, prototype);
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
