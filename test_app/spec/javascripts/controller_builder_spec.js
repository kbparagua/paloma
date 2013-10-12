
describe('Paloma.ControllerFactory', function(){

  var router = new Paloma.Router({namespace: '/', action: '#'});


  describe('#make(name)', function(){
    var factory = new Paloma.ControllerFactory(router),
        Controller;

    beforeEach(function(){
      Controller = factory.make('Resource');
    });


    it('returns a new Controller constructor', function(){
      expect(typeof Controller).toEqual('function');
    });

    it('saves the Controller constructor', function(){
      expect(factory.get('Resource')).toEqual(Controller);
    });
  });





  describe('#get(name)', function(){
    var factory = new Paloma.ControllerFactory(router),
        Controller = factory.make('Foo');

    describe('when controller exists', function(){
      it('returns the controller', function(){
        expect(factory.get('Foo')).toEqual(Controller);
      });
    });


    describe('when controller does not exist', function(){
      it('returns null', function(){
        expect(factory.get('WhatTheFuck')).toBeNull();
      });
    });

  });

});