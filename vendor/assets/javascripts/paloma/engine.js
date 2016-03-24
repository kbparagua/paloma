Paloma.Engine = function(controllerBuilder){
  this.controllerBuilder = controllerBuilder;
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

    this._executeControllerAction();
    this._clearRequest();
  },

  _executeControllerAction: function(){
    var controller = this._buildController();
    if (!controller) return;

    var callbackPerformer = new Paloma.BeforeCallbackPerformer(controller);
    callbackPerformer.perform( this._request.action );

    var method = controller[ this._request.action ];
    if (method) method.call(controller);

    this._lastRequest.executed = true;
  },

  _buildController: function(){
    return this.controllerBuilder.build({
      controller: this._request.controller,
      action: this._request.action,
      params: this._request.params
    });
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
