(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
    this._request = null;
  };

  Engine.prototype.start = function(){
    var resource = this._request['controller'],
        Controller = this.factory.get(resource);

    if (!Controller){
      return Paloma.warn('Paloma: undefined controller -> ' + resource);
    }

    var controller = new Controller( this._request['params'] ),
        action = this._request['action'],
        params = this._request['params'];

    if (!controller[action]){
      return Paloma.warn('Paloma: undefined action <' + action +
        '> for <' + resource + '> controller');
    }


    Paloma.log('Paloma: Execute ' + resource + '#' + action + ' with');
    Paloma.log(params);

    controller[ this._request['action'] ]();
  };


  Engine.prototype.setRequest = function(resource, action, params){
    this._request = {controller: resource, action: action, params: params};
  };


  Engine.prototype.getRequest = function(key){
    return (!key ? this._request : this._request[key]);
  };


  Paloma.Engine = Engine;

})(window.Paloma);
