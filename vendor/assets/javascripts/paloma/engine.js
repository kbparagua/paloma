Paloma.Engine = function(config){
  this.builder = config.builder;
  this._clearRequest();
};

Paloma.Engine.prototype = {

  setRequest: function(options){
    this._request = {
      id: options.id,
      controller: options.resource,
      action: options.action,
      params: options.params,
      executed: false
    };
  },

  hasRequest: function(){
    return this._request != null;
  },

  lastRequest: function(){
    return this._lastRequest = this._lastRequest || {executed: false};
  },

  start: function(){
    if ( this._shouldStop() ) return;

    this._logRequest();
    this._lastRequest = this._request;

    var controllerClass = this.builder.get( this._request.controller );

    if (controllerClass){
      var controller = new controllerClass( this._request.params );
      this._executeActionOf(controller);
    }

    this._clearRequest();
  },

  _executeActionOf: function(controller){
    var callback = controller[ this._request.action ];

    if (callback){
      callback.call(controller);
      this._lastRequest.executed = true;
    }
  },

  _shouldStop: function(){
    if ( !this.hasRequest() ) return true;
    if ( this._request.id == this.lastRequest().id ) return true;

    return false;
  },

  _logRequest: function(){
    Paloma.log(
      'Paloma: ' + this._request.controller + '#' +
      this._request.action + ' with params:'
    );

    Paloma.log( this._request.params );
  },

  _clearRequest: function(){
    this._request = null;
  }
};
