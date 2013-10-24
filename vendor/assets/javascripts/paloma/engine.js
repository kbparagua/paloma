(function(Paloma){

  var Engine = function(config){
    this.router = config.router;
    this.factory = config.factory;
    this.restart();
  };


  Engine.prototype.start = function(){
    for (var i = 0, n = this.requests.length; i < n; i++){
      var request = this.requests[i];

      console.log('Processing request with params:');
      console.log(request.params);

      var controllerName = this.router.controllerFor(request.resource),
          action = request.action,
          redirect = this.router.redirectFor(request.resource, action);

      if (redirect){
        controllerName = redirect['controller'];
        action = redirect['action'];
      }

      console.log('mapping <' + request.resource + '> to controller <' + controllerName + '>');
      console.log('mapping action <' + request.action + '> to controller action <' + action + '>');

      var Controller = this.factory.get(controllerName);

      if (!Controller){
        console.warn('Paloma: undefined controller -> ' + controllerName);
        continue;
      }

      var controller = new Controller(request.params);

      if (!controller[action]){
        console.warn('Paloma: undefined action <' + action +
          '> for <' + controllerName + '> controller');
        continue;
      }

      controller[action]();
    }

    this.restart();
  };


  Engine.prototype.restart = function(){
    this.requests = [];
  };


  Engine.prototype.request = function(resource, action, params){
    this.requests.push({resource: resource,
                        action: action,
                        params: params});
  };


  Paloma.Engine = Engine;

})(window.Paloma);
