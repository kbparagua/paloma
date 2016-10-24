Paloma.BeforeCallbackPerformer = function(controller){
  this.controller = controller;
  this.entries = controller.before || [];
  this.action = null;
};

Paloma.BeforeCallbackPerformer.prototype = {

  perform: function(action){
    this.action = action;
    this._executeCallbacks();
  },

  _executeCallbacks: function(){
    for (var i = 0, n = this._callbacks().length; i < n; i++)
      this._executeCallback( this._callbacks()[i] );
  },

  _executeCallback: function(name){
    var callback = this.controller[name];
    if (callback) callback.call(this.controller);
  },

  _callbacks: function(){
    if (this._callbackList) return this._callbackList;

    this._callbackList = [];

    for (var i = 0, n = this.entries.length; i < n; i++){
      var entry = this.entries[i];

      this._callbackList =
        this._callbackList.concat( this._getCallbacksIfForAction(entry) );
    }

    return this._callbackList;
  },

  _getCallbacksIfForAction: function(entry){
    var parsedEntry = this._parseEntry(entry);

    if (
      this._actionIsOn(parsedEntry.actions) ||
      this._allIsOn(parsedEntry.actions)
    )
      return parsedEntry.callbacks;

    return [];
  },

  _actionIsOn: function(actions){
    return actions.indexOf(this.action) != -1;
  },

  _allIsOn: function(actions){
    return actions.indexOf('all') != -1;
  },

  _parseEntry: function(entry){
    var parts = entry.split('->'),
        data = {actions: [], callbacks: []};

    if (parts[0]) data.actions = parts[0].trim().split(' ');
    if (parts[1]) data.callbacks = parts[1].trim().split(' ');

    return data;
  }

};
