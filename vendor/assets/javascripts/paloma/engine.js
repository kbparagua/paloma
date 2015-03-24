(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
    this._request = null;
  };

  Engine.prototype.start = function(){
    // Do not execute if there is no request available.
    if ( !this._request ) return;

    // Do not execute if already executed.
    //
    // This happens when using turbolinks,
    // if a page using js(false) is rendered
    // after a page with executed js, then the
    // previous js will be executed again.
    if ( this._request.executed ) return;

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

    this._request.executed = true;
  };


  //
  // options:
  //  resource
  //  action
  //  params
  //  id
  //
  Engine.prototype.setRequest = function(options){
    this._request = {
      id: options.id,
      controller: options.resource,
      action: options.action,
      params: options.params,
      executed: false
    };
  };


  Engine.prototype.getRequest = function(key){
    return (!key ? this._request : this._request[key]);
  };


  Paloma.Engine = Engine;

})(window.Paloma);
