describe('Paloma.ControllerClassFactory', function(){

  var _factory = null;
  function factory(){ return _factory; }

  function newFactory(){
    _factory = new Paloma.ControllerClassFactory();
    return _factory;
  }



  describe('#make(controllerAndParent, prototype)', function(){
    describe('when controller is not yet existing', function(){
      it('creates a new controller', function(){
        var controller = newFactory().make('MyController'),
            instance = new controller();

        expect(instance instanceof Paloma.BaseController).toBeTruthy();
      });

      describe('when prototype is present', function(){
        it('adds the prototype to the controller', function(){
          var controller = newFactory().make('MyController', {a: 100});

          expect(controller.prototype.a).toEqual(100);
        });
      });

      describe('when parent is present', function(){
        it('creates a subclass of that parent', function(){
          var parent = newFactory().make('Parent'),
              child = factory().make('Child < Parent');

          var controller = new child();
          expect(controller instanceof parent).toBeTruthy();
        });
      });
    });

    describe('when controller is already existing', function(){
      it('returns the existing controller', function(){
        var controller = newFactory().make('test2');
        expect( factory().make('test2') ).toEqual(controller);
      });

      describe('when prototype is present', function(){
        var controller = newFactory().make('Test', {number: 9});
        factory().make('Test', {number: 10});

        it('updates the current prototype', function(){
          expect(controller.prototype.number).toEqual(10);
        });
      });

      describe('when parent is present', function(){
        var oldParent = newFactory().make('OldParent'),
            newParent = factory().make('NewParent');

        describe('when no previous parent', function(){
          var child = factory().make('ChildA');
          factory().make('ChildA < NewParent');

          var instance = new child();

          it('assigns the new parent', function(){
            expect(instance instanceof newParent).toBeTruthy();
          });
        });

        describe('when has previous parent', function(){
          var child = factory().make('ChildB < OldParent');
          factory().make('ChildB < NewParent');

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
        expect( newFactory().get('unknown') ).toBeNull();
      });
    });

    describe('when name has match', function(){
      it('returns the matched controller', function(){
        var controller = newFactory().make('myController');
        expect( factory().get('myController') ).toEqual(controller);
      });
    });
  });

});
