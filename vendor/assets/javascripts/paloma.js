window.Paloma = window.Paloma || {};


(function(P){

  // Initialize Containers
  P.Resources = [];


  P.Resource = function(options){

  };


  // Filters
  P.Resource.prototype.perform = function(){

  };


  P.Resource._defaultOptions = function(options){
    var values = {};
    values['extend'] = options['extend'] != null ? options['extend'] : null;

    return values;
  };




})(window.Paloma);