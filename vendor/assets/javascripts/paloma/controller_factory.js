Paloma.ControllerFactory = function(){
  this._controllers = {};
};

Paloma.ControllerFactory.prototype = {

  make: function(name, prototype){
    prototype = prototype || {};

    var controller = this._createConstructor();

    this._merge(controller.prototype, prototype);
    this._controllers[name] = controller;

    return controller;
  },

  update: function(name, prototype){
    prototype = prototype || {};

    var controller = this.get(name);
    this._merge(controller.prototype, prototype)

    return controller;
  },

  get: function(name){
    return this._controllers[name] || null;
  },

  _createConstructor: function(){
    var constructor = function(params){ Paloma.Controller.call(this, params); };

    constructor.prototype.__proto__ = Paloma.Controller.prototype;

    return constructor;
  },

  _merge: function(target, source){
    for (var key in source)
      if (source.hasOwnProperty(key)) target[key] = source[key];
  }

};
