Paloma.ControllerBuilder = function(){
  this._controllers = {};
  this._inheritanceSymbol = '<';
};

Paloma.ControllerBuilder.prototype = {

  build: function(nameAndParent, prototype){
    var parts = this._extractParts(nameAndParent),
        controller = this._getOrCreate( parts.name );

    this._updatePrototype(controller, prototype);
    this._updateParent(controller, parts.parent);

    return controller;
  },

  get: function(name){
    return this._controllers[name] || null;
  },

  _updateParent: function(controller, parent){
    if (parent) controller.prototype.__proto__ = parent.prototype;
  },

  _updatePrototype: function(controller, newPrototype){
    for (var k in newPrototype)
      if (newPrototype.hasOwnProperty(k))
        controller.prototype[k] = newPrototype[k];
  },

  _getOrCreate: function(name){
    return this.get(name) || this._create(name);
  },

  _create: function(name){
    var controller = function(params){
      Paloma.Controller.call(this, params);
    };

    controller.prototype.__proto__ = Paloma.Controller.prototype;

    this._controllers[name] = controller;
    return controller;
  },

  _extractParts: function(nameAndParent){
    var parts = nameAndParent.split( this._inheritanceSymbol );

    var name = parts[0].trim(),
        parent = parts[1];

    if (parent) parent = parent.trim();

    return {name: name, parent: parent};
  }

};
