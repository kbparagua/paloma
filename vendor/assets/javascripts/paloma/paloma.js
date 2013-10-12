(function(Paloma){


  Paloma.router = new Paloma.Router({namespace: '/', action: '#'});
  Paloma._controllerFactory = new Paloma.ControllerFactory(Paloma.router);


  Paloma.controller = function(name){
    return Paloma._controllerFactory.get(name) ||
            Paloma._controllerFactory.make(name);
  };


  Paloma.engine = new Paloma.Engine({router: Paloma.router,
                                    factory: Paloma._controllerFactory});

})(window.Paloma);