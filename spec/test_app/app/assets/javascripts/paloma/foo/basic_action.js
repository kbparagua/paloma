(function(){
var _x = Paloma.variableContainer,
  _H = Paloma.helpers,
  _h = _H['foo'];
  

Paloma.callbacks['foo']['basic_action'] = function(params)
{
  window.callback = "['foo']['basic_action']";
  window.params = params;

  _x.xVisibility.push('Foo');
};

})();