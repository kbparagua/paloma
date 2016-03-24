Paloma.ControllerBuilder = function(classFactory){
  this.classFactory = classFactory;
  this.options = {};
};

Paloma.ControllerBuilder.prototype = {

  build: function(options){
    this.options = options;

    var ControllerClass = this._controllerClass(),
    if ( !ControllerClass ) return null;

    return new ControllerClass( this._buildParams() );
  },

  _controllerClass: function(){
    return this.classFactory.get( this.options.controller );
  },

  _buildParams: function(){
    var params = {
      _controller: this.options.controller,
      _action: this.options.action
    };

    for (var k in this.options.params)
      if (this.options.hasOwnProperty(k))
        params[k] = this.options.params[k];

    return params;
  }

};
