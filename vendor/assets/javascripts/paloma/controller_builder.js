(function(Paloma){


  var ControllerFactory = function(router){
    this.instances = {};
    this.router = router;
  };


  ControllerFactory.prototype.make = function(name){
    var config = this.router.parse(name),
        scope = this.instances;

    // Create namespaces.
    for (var i = 0, n = config['namespaces'].length; i < n; i++){
      var namespace = config['namespaces'][i];
      scope[namespace] = scope[namespace] || {};
      scope = scope[namespace];
    }

    return scope[config['controller']] = createConstructor();
  };


  ControllerFactory.prototype.get = function(name){
    var config = this.router.parse(name),
        scope = this.instances;

    for (var i = 0, n = config['controllerPath'].length; i < n; i++){
      var path = config['controllerPath'][i];

      if (scope[path] != null){ scope = scope[path]; }
      else { return null; }
    }

    return scope;
  };


  var createConstructor = function(){
    var constructor = function(params){ this.params = params; }

    $.extend(constructor, Paloma.Controller);
    $.extend(constructor.prototype, Paloma.Controller.prototype);

    return constructor;
  };





  Paloma.ControllerFactory = ControllerFactory;

})(window.Paloma);