Paloma.Router = function(options){
  options = options || {};
  this.namespaceDelimiter = options.namespaceDelimiter;

  if (!this.namespaceDelimiter)
    throw "Paloma.Router: namespaceDelimiter option is required.";
};

Paloma.Router.prototype = {

  parse: function(path){
    var parts = path.split(this.namespaceDelimiter),
        controller = parts.pop(),
        namespaces = parts;

    var controllerPath = namespaces.concat([controller]);

    return {
      controllerPath: controllerPath,
      namespaces: namespaces,
      controller: controller
    };
  }

};


