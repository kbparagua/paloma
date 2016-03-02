Paloma.ControllerFactory = function(router){
  this.instances = {};
  this.router = router;
};

Paloma.ControllerFactory.prototype = {

  make: function(name){
    var config = this.router.parse(name),
        scope = this.instances;

    // Create namespaces.
    for (var i = 0, n = config['namespaces'].length; i < n; i++){
      var namespace = config['namespaces'][i];
      scope[namespace] = scope[namespace] || {};
      scope = scope[namespace];
    }

    return scope[config['controller']] = this._createConstructor();
  },

  get: function(name){
    var config = this.router.parse(name),
        scope = this.instances;

    for (var i = 0, n = config['controllerPath'].length; i < n; i++){
      var path = config['controllerPath'][i];

      if (scope[path] != null){ scope = scope[path]; }
      else { return null; }
    }

    return scope;
  },

  _createConstructor: function(){
    var constructor = function(params){ Paloma.Controller.call(this, params); };

    constructor.prototype.__proto__ = Paloma.Controller.prototype;

    return constructor;
  }

};
