(function(Paloma){



  var Router = function(config){
    this.controllers = {};
    this.redirects = {};

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


  Router.prototype.resource = function(resource, option){
    option = option || {};
    this.controllers[resource] = option['controller'] || resource;
  };


  Router.prototype.redirect = function(path, option){
    option = option || {};
    this.redirects[path] = this.parse(option['to'] || path);
  };


  Router.prototype.controllerFor = function(resource){
    return this.controllers[resource] || resource;
  };


  Router.prototype.redirectFor = function(resource, action){
    var path = resource + this.delimiters.action + action,
        redirect = this.redirects[path];

    if (!redirect){ return null; }

    return {controller: redirect['controllerPath'].join(this.delimiters.namespace),
            action: redirect['action']};
  };



  Paloma.Router = Router;

})(window.Paloma);