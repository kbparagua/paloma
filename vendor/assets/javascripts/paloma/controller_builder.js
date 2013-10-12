(function(Paloma){

  var router = Paloma.RouteHelper;

  var ControllerBuilder = function(){
    this.instances = {};
  };


  ControllerBuilder.prototype.register = function(name){
    var config = router.parse(name),
        scope = this.instances;

    // Create namespaces
    for (var i = 0, n = config['namespaces'].length; i < n; i++){
      var namespace = config['namespaces'][i];
      scope[namespace] = scope[namespace] || {};
      scope = scope[namespace];
    }

    scope[config['controller']] = 'Yehey';
  };


  Paloma.ControllerBuilder = ControllerBuilder;
  Paloma.Controller = new ControllerBuilder();

})(window.Paloma);