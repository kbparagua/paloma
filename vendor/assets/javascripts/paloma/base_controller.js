(function(){

  Paloma.BaseController = function(params){
    this.params = params;
  };

  Paloma.BaseController.prototype = {

    before: [],

    execute: function(methodName){
      var callbacks = getCallbacksFor.call(this, methodName);
      executeCallbacks(this, callbacks);
    }

  };

  function getCallbacksFor(methodName){
    var callbacks = [];

    for (var i = 0, n = this.before.length; i < n; i++){
      var entry = parseEntry( this.before[i] );

      if ( entry.methods.indexOf(methodName) != -1 )
        callbacks = callbacks.concat(entry.callbacks);
    }

    return callbacks;
  }

  function parseEntry(beforeEntry){
    var parts = beforeEntry.split('->'),
        data = {methods: [], callbacks: []};

    if (parts[0]) data.methods = parts[0].trim().split(' ');
    if (parts[1]) data.callbacks = parts[1].trim().split(' ');

    return data;
  }

  function executeCallbacks(callbacks){
    for (var i = 0, n = callbacks.length; i < n; i++){
      var name = callbacks[i],
          callback = this[name];

      callback.call(this);
    }
  };

})();

