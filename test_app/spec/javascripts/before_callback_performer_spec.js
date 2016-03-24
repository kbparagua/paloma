describe('Paloma.BeforeCallbackPerformer', function(){
  describe('#perform(action)', function(){

    var Controller = Paloma.controller('MyController', {
      before: [
        'all -> initialize doThat',
        'singleCallback unknown -> doSomething',
        'multiCallback -> doSomething doAnotherThing'
      ],

      initialize: function(){
        this.didWhat = [];
      },

      did: function(what){ return this.didWhat.indexOf(what) >= 0; },

      noCallback: function(){ console.log('I have no callback.'); },
      singleCallback: function(){ console.log('Single callback.'); },
      multiCallback: function(){ console.log('Multiple callbacks.')},

      doThat: function(){ this.didWhat.push('that'); },
      doSomething: function(){ this.didWhat.push('something'); },
      doAnotherThing: function(){ this.didWhat.push('anotherThing') }
    });

    function itPerformsCallbackForAll(controller){
      it('performs callback for all', function(){
        expect( controller.did('that') ).toBeTruthy();
      });
    };

    describe('when there is no matched callback', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('noCallback');

      it('will not perform any callback', function(){
        expect( controller.did('something') ).toBeFalsy();
      });

      itPerformsCallbackForAll(controller);
    });

    describe('when there is one matched callback', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('singleCallback');

      it('will perform the matched callback', function(){
        expect( controller.did('something') ).toBeTruthy();
      });

      itPerformsCallbackForAll(controller);
    });

    describe('when there is more than one matched callbacks', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('multiCallback');

      it('will perform all the matched callbacks', function(){
        expect( controller.did('something') && controller.did('anotherThing') ).
          toBeTruthy();
      });

      it('will perform the callbacks in order of definition', function(){
        expect(controller.didWhat).toEqual([
          'that', 'something', 'anotherThing'
        ]);
      });

      itPerformsCallbackForAll(controller);
    });

  });
});
