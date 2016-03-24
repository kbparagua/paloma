describe('Paloma.ControllerBuilder', function(){

  var TestController = Paloma.controller('Test');


  describe('#build(options)', function(){

    describe('when options.controller has no match', function(){
      var factory = {get: function(controller){ return null; }},
          builder = new Paloma.ControllerBuilder(factory);

      it('returns null', function(){
        var options = {controller: 'Test', action: 'show'};
        expect( builder.build(options) ).toBeNull();
      });
    });

    describe('when options.controller has a match', function(){
      var factory = {get: function(controller){ return TestController; }},
          builder = new Paloma.ControllerBuilder(factory);

      var options = {
        controller: 'Test',
        action: 'show',
        params: {a: 1, b: 2}
      };

      var controller = builder.build(options);

      it('returns a new instance of the controller class', function(){
        expect(controller instanceof TestController).toBeTruthy();
      });

      it("initializes controller instance's params", function(){
        var expectedParams = {_controller: 'Test', _action: 'show', a: 1, b: 2};
        var correct = true;

        for (var k in expectedParams){
          if (controller.params[k] != expectedParams[k])
            correct = false;
        }

        expect(correct).toBeTruthy();
      });
    });

  });

});
