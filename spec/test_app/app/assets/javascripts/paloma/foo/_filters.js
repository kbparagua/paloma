(function(){
  var filter = new Paloma.FilterScope('foo');
  var _x = Paloma.variableContainer;

 
  filter.as('Before Foo').
  before_all().perform(function(params){
    _x.xVisibility = ['Before Foo'];
  });
 

  filter.as('After Foo').
  after_all().perform(function(params){
    _x.xVisibility.push('After Foo');
  });


  filter.as('Around Foo').
  around_all().perform(function(params){
    _x.xVisibility.push('Around Foo');
    window.xVisibilityFinal = _x.xVisibility;
  });

})();
