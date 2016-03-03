(function(Paloma){

  Paloma._controllerFactory = new Paloma.ControllerFactory();

  //
  // Declare Paloma controllers using this method.
  // Will return a new constructor if the no controller with the passed name
  // is found, else it will just return the current constructor.
  //
  Paloma.controller = function(name, prototype){
    prototype = prototype || {};

    var nameParts = name.split('<'),
        controller = nameParts[0].trim(),
        parent = nameParts[1];

    var controllerClass =
      Paloma._controllerFactory.get(controller) ?
        Paloma._controllerFactory.update(controller, prototype) :
        Paloma._controllerFactory.make(controller, prototype);

    if (parent){
      parent = parent.trim();
      var parentClass = Paloma._controllerFactory.get(parent);
      if (!parentClass) throw "Undefined Paloma controller: " + parent;

      controllerClass.prototype.__proto__ = parentClass.prototype;
    }

    return controllerClass;
  };


  Paloma.engine = new Paloma.Engine({factory: Paloma._controllerFactory});

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
