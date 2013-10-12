window.Paloma = window.Paloma || {};

(function(P){

  var ControllerBuilder = function(){
    this.instances = {};
  };


  ControllerBuilder.prototype.register = function(name){

  };


  ControllerBuilder.prototype._parse = function(name){
    var parts = {},
        namespacedName = name.split('/');

    if (namespacedName.length > 1){
      // The last part of the namespacedName will be the controller name.
      for (var i = 0, lastIndex = namespacedName.length - 1; i < lastIndex; i++){
        namespace = namespacedName[i];

      }
    }
  };


  P.Controller = new ControllerBuilder();




  var Controller = function(){

  };



})(window.Paloma);