Paloma.Agent = function(controller){
  this.controller = controller;
};

Paloma.Agent.prototype = {

  perform: function(action){
    var callbacks = this._getCallbacksFor(action);
    this._executeCallbacks.call(callbacks);
  },

  _getCallbacksFor: function(action){
    var callbacks = [];

    for (var i = 0, n = this.controller.before.length; i < n; i++){
      var entry = parseEntry( this.before[i] );

      if ( entry.methods.indexOf(methodName) != -1 )
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

  _executeCallbacks: function(callbacks){
    for (var i = 0, n = callbacks.length; i < n; i++){
      var name = callbacks[i],
          callback = this.controller[name];

      callback.call(this.controller);
    }
  };


};
