(function(Paloma){

  var Router = function(namespaceDelimiter){
    this.namespaceDelimiter = namespaceDelimiter;
  };


  Router.prototype.parse = function(path){
    var parts = path.split(this.namespaceDelimiter),
        controller = parts.pop(),
        namespaces = parts;

    var controllerPath = namespaces.concat([controller]);

    return {controllerPath: controllerPath,
            namespaces: namespaces,
            controller: controller};
  };


  Paloma.Router = Router;

})(window.Paloma);