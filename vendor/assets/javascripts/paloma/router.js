(function(Paloma){



  var Router = function(config){
    this.delimiters = {};
    this.delimiters.namespace = config['namespace'];
    this.delimiters.action = config['action'];
  };


  Router.prototype.parse = function(path){
    var namespaced = path.split(this.delimiters.namespace),
        namespaces = namespaced.slice(0, namespaced.length - 1),
        controllerPart = namespaced.pop();

    var actioned = controllerPart.split(this.delimiters.action),
        controller = actioned[0],
        action = actioned.length == 1 ? null : actioned.pop();

    var controllerPath = namespaces.concat([controller]);

    return {controllerPath: controllerPath,
            namespaces: namespaces,
            controller: controller,
            action: action};
  };



  Paloma.Router = Router;

})(window.Paloma);