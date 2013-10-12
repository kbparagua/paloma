
describe('Paloma.Router', function(){
  var delimiter = {namespace: '/', action: '#'},
      router = new Paloma.Router(delimiter);

  describe('#parse(path)', function(){

    describe('when path has a namespace', function(){
      var result;

      beforeEach(function(){
        result = router.parse('Foo/Bar/Baz/Controller#action');
      });

      it('returns the array of the namespaces', function(){
        expect(result.namespaces).toEqual(['Foo', 'Bar', 'Baz']);
      });

      it('returns the controller', function(){
        expect(result.controller).toEqual('Controller');
      });

      it('returns the action', function(){
        expect(result.action).toEqual('action');
      });

      it('returns the controllerPath', function(){
        expect(result.controllerPath).toEqual(['Foo', 'Bar', 'Baz', 'Controller']);
      });
    });



    describe('when path has no namespace', function(){
      var result;

      beforeEach(function(){
        result = router.parse('Controller#action');
      });

      it('returns an empty array of namespaces', function(){
        expect(result.namespaces).toEqual([]);
      });

      it('returns the controller', function(){
        expect(result.controller).toEqual('Controller');
      });

      it('returns the action', function(){
        expect(result.action).toEqual('action');
      });

      it('returns the controllerPath', function(){
        expect(result.controllerPath).toEqual(['Controller']);
      });
    });

  });





  describe('#controllerFor(resource)', function(){

    var resource = 'MySuperResource';

    describe('when no route is found', function(){
      it('returns the resource', function(){
        var controller = router.controllerFor(resource);
        expect(controller).toEqual(resource);
      });
    });


    describe('when route is found', function(){
      it('returns the set controller', function(){
        router.resource(resource, {controller: 'MyController'});

        var controller = router.controllerFor(resource);
        expect(controller).toEqual('MyController');
      });
    });
  });





  describe('#redirectFor(resource, action)', function(){
    var router = new Paloma.Router(delimiter),
        result;

    describe('when has a redirect', function(){
      beforeEach(function(){
        router.redirect('Foo#edit', {to: 'Bar#revise'});
        result = router.redirectFor('Foo', 'edit');
      });

      it('returns controller of the redirect', function(){
        expect(result.controller).toEqual('Bar');
      });

      it('returns action of the redirect', function(){
        expect(result.action).toEqual('revise');
      });

      router.reset();
    });


    describe('when has no redirect', function(){
      var router = new Paloma.Router(delimiter),
          result = router.redirectFor('Foo', 'edit');

      it('returns null', function(){
        expect(result).toBeNull();
      });
    });

  });

});