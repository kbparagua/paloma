(function(Paloma){

  var NAMESPACE_DELIMITER = '/',
      ACTION_DELIMITER = '#';


  var Helper = {};



  Helper.parse = function(route){
    var namespaced = route.split(NAMESPACE_DELIMITER),
        namespaces = namespaced.slice(0, namespaced.length - 1),
        controllerPart = namespaced.pop();

    var actioned = controllerPart.split(ACTION_DELIMITER),
        controller = actioned[0],
        action = actioned.length == 1 ? null : actioned.pop();

    return {namespaces: namespaces,
            controller: controller,
            action: action};
  };


  Paloma.RouteHelper = Helper;

})(window.Paloma);