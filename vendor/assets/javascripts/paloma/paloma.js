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


  Paloma.executeHook = function(){
    var $hook = $('.js-paloma-hook:first script:first');

    if ($hook.length == 0){ return; }

    var hook = $hook.html();
    eval(hook);
  };


})(window.Paloma);