(function(Paloma){

  Paloma._router = new Paloma.Router('/');
  Paloma._controllerFactory = new Paloma.ControllerFactory(Paloma._router);

  //
  // Declare Paloma controllers using this method.
  // Will return a new constructor if the no controller with the passed name
  // is found, else it will just return the current constructor.
  //
  Paloma.controller = function(name){
    return Paloma._controllerFactory.get(name) ||
            Paloma._controllerFactory.make(name);
  };


  Paloma.engine = new Paloma.Engine({factory: Paloma._controllerFactory});

  Paloma._executeHook = function(){
    var hooks = document.getElementsByClassName('js-paloma-hook');
    if (hooks.length == 0) return;

    for (var i = 0, n = hooks.length; i < n; i++){
      var hook = hooks[i],
          script = hook.getElementsByTagName('script')[0];

      if (script) eval(script.innerHTML);
    }
  };

  Paloma.start = function(){
    if ( !this.engine.hasRequest() ) this._executeHook();
    if ( this.engine.hasRequest() ) this.engine.start();
  };

  Paloma.isExecuted = function(){
    return this.engine.lastRequest().executed;
  };



})(window.Paloma);
