(function(Paloma){

  Paloma._controllerFactory = new Paloma.ControllerFactory();

  Paloma.controller = function(name){
    return Paloma._controllerFactory.get(name) ||
            Paloma._controllerFactory.make(name);
  };




})(window.Paloma);