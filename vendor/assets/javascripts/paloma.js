window.Paloma = window.Paloma || {};


(function(P){

  // Initialize Containers
  P.Resources = {};


  P.execute = function(callback){
    var resource = P.Resources[ callback['resource'] ];
    if (resource == undefined){ return false; }

    var instance = new resource(),
        action = callback['action'];

    if (instance[action] != null){ instance[action](callback['params']); }
  };



  P.Resource = function(options){};


  P.Resource.create = function(name, options){
    options = defaultOptions(options);

    var path = name.split('.'),
        resource = path.pop(),
        namespace = path.pop();

    var Resource = function(){};

    if (namespace != null){
      P.Resources[namespace] = P.Resource[namespace] || {};
      return P.Resources[namespace][resource] = Resource;
    }
    else {
      return P.Resources[resource] = Resource;
    }
  };



  // Filters
  P.Resource.prototype.perform = function(){

  };


  var defaultOptions = function(options){
    options = options || {};

    var values = {};
    values['extend'] = options['extend'] != null ? options['extend'] : null;

    return values;
  };


})(window.Paloma);