Paloma.Agent = function(controller){
  this.controller = controller;
};

Paloma.Agent.prototype = {

  perform: function(action){
    var callbacks = this._getCallbacksFor(action);
    this._executeCallbacks(callbacks);
  },

  _getCallbacksFor: function(action){
    var callbacks = [];

    for (var i = 0, n = this.controller.before.length; i < n; i++){
      var entry = this._parseEntry( this.controller.before[i] );

      if ( this._methodIsIncluded(action, entry.methods) )
        callbacks = callbacks.concat(entry.callbacks);
    }

    return callbacks;
  },

  _parseEntry: function(beforeEntry){
    var parts = beforeEntry.split('->'),
        data = {methods: [], callbacks: []};

    if (parts[0]) data.methods = parts[0].trim().split(' ');
    if (parts[1]) data.callbacks = parts[1].trim().split(' ');

    return data;
  },

  _methodIsIncluded: function(name, methods){
    return methods.indexOf(name) != -1 || methods.indexOf('all') != -1;
  },

  _executeCallbacks: function(callbacks){
    for (var i = 0, n = callbacks.length; i < n; i++){
      var name = callbacks[i],
          callback = this.controller[name];

      if (callback) callback.call(this.controller);
    }
  }


};
