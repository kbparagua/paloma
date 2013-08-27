(function(){

  var self = Paloma.Resource.create('Foo');

  self.prototype.basicAction = function(){
    window.callback = "['foo']['basic_action']";
    window.params = params;

    window.helperMethodValue = _l.helperMethod();
    window.helperVariableValue = _l.helperVariable;
    window.overriden = _l.toBeOverriden();

    _x.xVisibility.push('Foo');

    window.locals = _l;
  };


})();