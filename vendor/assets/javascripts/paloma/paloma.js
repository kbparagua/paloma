(function(Paloma){

  Paloma.config = {};

  // Defaults
  Paloma.config.ignoreMissingController = true;


  Paloma.router = new Paloma.Router({namespace: '/', action: '#'});


  //
  //
  // Controller Interface.
  //
  //
  Paloma._controllerFactory = new Paloma.ControllerFactory(Paloma.router);

  Paloma.controller = function(name){
    return Paloma._controllerFactory.get(name) ||
            Paloma._controllerFactory.make(name);
  };









  //
  //
  // Request Interface.
  //
  //
  Paloma.engine = {requests: []};

  Paloma.engine.start = function(){
    var requests = Paloma.engine.requests;

    for (var i = 0, n = requests.length; i < n; i++){
      var request = requests[i];

      console.log('Processing request with params:');
      console.log(request.params);

      var controllerName = router.controllerFor(request.resource),
          action = request.action,
          redirect = router.redirectFor(request.resource, action);

      if (redirect){
        controllerName = redirect['controller'];
        action = redirect['action'];
      }

      console.log('mapping <' + request.resource + '> to controller <' + controllerName + '>');
      console.log('mapping action <' + request.action + '> to controller action <' + action + '>');

      var Controller = Paloma._controllerFactory.get(controllerName);

      if (!Controller){
        return console.warn('Paloma: undefined controller -> ' + controllerName);
      }

      var controller = new Controller(request.params);

      if (!controller[action]){
        return console.warn('Paloma: undefined action <' + action +
                              '> for <' + controllerName + '> controller');
      }

      controller[action]();
    }
  };
})(window.Paloma);