(function(){

  var self = Paloma.Resource.create('Foo');

  self.prototype.basicAction = function(params){
    console.log(params);
  };

})();