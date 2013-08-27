window.Paloma = window.Paloma || {};


(function(P){

  // Initialize Containers
  P.Resources = {};


  P.execute = function(callback){
    var resource = P.Resources[callback.resource];
    if (resource == undefined){ return false; }

    var action = resource[action];
    if (action == undefined){ return false; }

    action(callback.params);
  };



  P.Resource = function(options){};


  P.Resource.create = function(name, options){
    options = defaultOptions(options);

    var path = name.split('.'),
        resource = name.pop(),
        namespace = name.pop();

    var constructor = function(){};

    if (namespace != null){
      P.Resources[namespace] = P.Resource[namespace] || {};
      P.Resources[namespace][resource] = constructor;
    }
    else {
      P.Resources[resource] = constructor;
    }

    return constructor;
  };



  // Filters
  P.Resource.prototype.perform = function(){

  };


  var defaultOptions = function(options){
    var values = {};
    values['extend'] = options['extend'] != null ? options['extend'] : null;

    return values;
  };


})(window.Paloma);