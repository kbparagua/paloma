(function(Paloma){

  var Engine = function(config){
    this.factory = config.factory;
    this._clearRequest();
  };

  Engine.prototype.start = function(){
    if ( !this._request ) return;
    if ( this._request.id == this.lastRequest().id ) return;

    this._lastRequest = this._request;

    var resource = this._request.controller,
        action = this._request.action,
        params = this._request.params;

    var Controller = this.factory.get(resource),
        controller = null;

    Paloma.log('Paloma: ' + resource + '#' + action + ' with params:');
    Paloma.log(params);

    if ( !Controller ) return true;
    controller = new Controller(params);

    if ( !controller[action] ) return true;
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
