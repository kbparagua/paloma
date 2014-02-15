(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
  };


  Engine.prototype.request = function(resource, action, params){
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
  };


  Paloma.Engine = Engine;

})(window.Paloma);
