Paloma.ControllerFactory = function(){
  this._controllers = {};
};

Paloma.ControllerFactory.prototype = {

  make: function(name){
    this._controllers[name] = this._createConstructor();
    return this.get(name);
  },

  get: function(name){
    return this._controllers[name] || null;
  },

  _createConstructor: function(){
    var constructor = function(params){ Paloma.Controller.call(this, params); };

    constructor.prototype.__proto__ = Paloma.Controller.prototype;

    return constructor;
  }

};
