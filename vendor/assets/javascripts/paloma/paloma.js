(function(Paloma){

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

      var Controller = Paloma.controller(request['path']),
          controller = new Controller(request['params']);

      controller[request['action']]();
    }
  };
})(window.Paloma);