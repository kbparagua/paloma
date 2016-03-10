describe('Paloma.ControllerBuilder', function(){

  var _builder = null;
  function builder(){ return _builder; }

  function newBuilder(){
    _builder = new Paloma.ControllerBuilder();
    return _builder;
  }



  describe('#build(controllerAndParent, prototype)', function(){
    describe('when controller is not yet existing', function(){
      it('creates a new controller', function(){
        var controller = newBuilder().build('MyController'),
            instance = new controller();

        expect(instance instanceof Paloma.BaseController).toBeTruthy();
      });

      describe('when prototype is present', function(){
        it('adds the prototype to the controller', function(){
          var controller = newBuilder().build('MyController', {a: 100});

          expect(controller.prototype.a).toEqual(100);
        });
      });

      describe('when parent is present', function(){
        it('creates a subclass of that parent', function(){
          var parent = newBuilder().build('Parent'),
              child = builder().build('Child < Parent');

          var controller = new child();
          expect(controller instanceof parent).toBeTruthy();
        });
      });
    });

    describe('when controller is already existing', function(){
      it('returns the existing controller', function(){
        var controller = newBuilder().build('test2');
        expect( builder().build('test2') ).toEqual(controller);
      });

      describe('when prototype is present', function(){
        var controller = newBuilder().build('Test', {number: 9});
        builder().build('Test', {number: 10});

        it('updates the current prototype', function(){
          expect(controller.prototype.number).toEqual(10);
        });
      });

      describe('when parent is present', function(){
        var oldParent = newBuilder().build('OldParent'),
            newParent = builder().build('NewParent');

        describe('when no previous parent', function(){
          var child = builder().build('ChildA');
          builder().build('ChildA < NewParent');

          var instance = new child();

          it('assigns the new parent', function(){
            expect(instance instanceof newParent).toBeTruthy();
          });
        });

        describe('when has previous parent', function(){
          var child = builder().build('ChildB < OldParent');
          builder().build('ChildB < NewParent');

          var instance = new child();

          it('updates removes the oldParent', function(){
            expect(instance instanceof oldParent).toBeFalsy();
          });

          it('assigns the new parent', function(){
            expect(instance instanceof newParent).toBeTruthy();
          });
        });
      });
    });
  });

  describe('#get(name)', function(){
    describe('when name has no match', function(){
      it('returns null', function(){
        expect( newBuilder().get('unknown') ).toBeNull();
      });
    });

    describe('when name has match', function(){
      it('returns the matched controller', function(){
        var controller = newBuilder().build('myController');
        expect( builder().get('myController') ).toEqual(controller);
      });
    });
  });

});
