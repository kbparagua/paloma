(function(){
var _x = Paloma.variableContainer,
  _L= Paloma.locals,
  _l = _L['foo'];


Paloma.callbacks['foo']['basic_action'] = function(params)
{
  window.callback = "['foo']['basic_action']";
  window.params = params;

  window.helperMethodValue = _l.helperMethod();
  window.helperVariableValue = _l.helperVariable;
  window.overriden = _l.toBeOverriden();

  _x.xVisibility.push('Foo');

  window.locals = _l;
};

})();