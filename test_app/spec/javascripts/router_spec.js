
describe('Paloma.Router', function(){
  var delimiter = '/',
      router = new Paloma.Router(delimiter);

  describe('#parse(path)', function(){

    describe('when path has a namespace', function(){
      var result;

      beforeEach(function(){
        result = router.parse('Foo/Bar/Baz/Controller');
      });

      it('returns the array of the namespaces', function(){
        expect(result.namespaces).toEqual(['Foo', 'Bar', 'Baz']);
      });

      it('returns the controller', function(){
        expect(result.controller).toEqual('Controller');
      });

      it('returns the controllerPath', function(){
        expect(result.controllerPath).toEqual(['Foo', 'Bar', 'Baz', 'Controller']);
      });
    });



    describe('when path has no namespace', function(){
      var result;

      beforeEach(function(){
        result = router.parse('Controller');
      });

      it('returns an empty array of namespaces', function(){
        expect(result.namespaces).toEqual([]);
      });

      it('returns the controller', function(){
        expect(result.controller).toEqual('Controller');
      });

      it('returns the controllerPath', function(){
        expect(result.controllerPath).toEqual(['Controller']);
      });
    });

  });

});