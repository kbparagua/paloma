Paloma.ControllerBuilder = function(){
  this._controllers = {};
  this._inheritanceSymbol = '<';
};

Paloma.ControllerBuilder.prototype = {

  build: function(controllerAndParent, prototype){
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
    if (parentClass) controller.prototype.__proto__ = parentClass.prototype;
  },

  _updatePrototype: function(controller, newPrototype){
    Paloma.utils.merge(controller.prototype, newPrototype);
  },

  _getOrCreate: function(name){
    return this.get(name) || this._create(name);
  },

  _create: function(name){
    var controller = function(params){
      Paloma.BaseController.call(this, params);
    };

    controller.prototype.__proto__ = Paloma.BaseController.prototype;

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
