(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
    this.lastRequest = null;
  };


  Engine.prototype.request = function(resource, action, params){
    this.lastRequest = null;

    var Controller = this.factory.get(resource);

    if (!Controller){
      return Paloma.warn('Paloma: undefined controller -> ' + resource);
    }

    var controller = new Controller(params);

    if (!controller[action]){
      return Paloma.warn('Paloma: undefined action <' + action +
        '> for <' + resource + '> controller');
    }

    Paloma.log('Paloma: Execute ' + resource + '#' + action + ' with');
    Paloma.log(params);

    controller[action]();
    this.lastRequest = {controller: resource, action: action, params: params};
  };


  Paloma.Engine = Engine;

})(window.Paloma);
