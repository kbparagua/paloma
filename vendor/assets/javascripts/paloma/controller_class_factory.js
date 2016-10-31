Paloma.ControllerClassFactory = function(){
  this._controllers = {};
  this._inheritanceSymbol = '<';
};

Paloma.ControllerClassFactory.prototype = {

  make: function(controllerAndParent, prototype){
    var parts = this._extractParts(controllerAndParent),
        controller = this._getOrCreate( parts.controller );

    this._updatePrototype(controller, prototype);
    this._updateParent(controller, parts.parent);

    return controller;
  },

  get: function(name){
    return this._controllers[name] || null;
  },

  _updateParent: function(controller, parent){
    if (!parent) return;

    var parentClass = this.get(parent);
    if (parentClass) controller.prototype = Object.create(parentClass.prototype, controller.prototype);
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
      Paloma.BaseController.call(this, params);
    };

    controller.prototype = Object.create(Paloma.BaseController.prototype);
    controller.prototype.constructor = controller;

    this._controllers[name] = controller;
    return controller;
  },

  _extractParts: function(controllerAndParent){
    var parts = controllerAndParent.split( this._inheritanceSymbol );

    var controller = parts[0].trim(),
        parent = parts[1];

    if (parent) parent = parent.trim();

    return {controller: controller, parent: parent};
  }

};
