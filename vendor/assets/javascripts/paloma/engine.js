(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
    this._clearRequest();
  };

  Engine.prototype.start = function(){
    if ( !this._request ) return;

    this._lastRequest = this._request;

    var resource = this._request.controller,
        Controller = this.factory.get(resource);

    if ( !Controller )
      return this._stopWithWarning(
        'Paloma: undefined controller -> ' + resource
      );

    var controller = new Controller( this._request.params ),
        action = this._request.action,
        params = this._request.params;

    if ( !controller[action] )
      return this._stopWithWarning(
        'Paloma: undefined action <' + action + '> for <' +
        resource + '> controller'
      );

    Paloma.log('Paloma: Execute ' + resource + '#' + action + ' with');
    Paloma.log(params);

    controller[action]();

    this._lastRequest.executed = true;
    this._clearRequest();
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

  Engine.prototype.lastRequest = function(){
    return this._lastRequest || {executed: false};
  };

  Engine.prototype.hasRequest = function(){
    return this._request != null;
  };

  Engine.prototype._clearRequest = function(){
    this._request = null;
  };

  Engine.prototype._stopWithWarning = function(warning){
    Paloma.warn(warning);
    this._clearRequest();
  };

  Paloma.Engine = Engine;

})(window.Paloma);
