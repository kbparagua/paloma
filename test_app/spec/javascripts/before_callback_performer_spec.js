describe('Paloma.BeforeCallbackPerformer', function(){
  describe('#perform(action)', function(){

    var Controller = Paloma.controller('MyController', {
      before: [
        'all -> doThat',
        'singleCallback unknown -> doSomething',
        'multiCallback -> doSomething doAnotherThing'
      ],

      didThat: false,
      didSomething: false,
      didAnotherThing: false,

      noCallback: function(){ console.log('I have no callback.'); },
      singleCallback: function(){ console.log('Single callback.'); },
      multiCallback: function(){ console.log('Multiple callbacks.')},

      doThat: function(){ this.didThat = true; },
      doSomething: function(){ this.didSomething = true; },
      doAnotherThing: function(){ this.didAnotherThing = true; }
    });

    function itPerformsCallbackForAll(controller){
      it('performs callback for all', function(){
        expect(controller.didThat).toBeTruthy();
      });
    };

    describe('when there is no matched callback', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('noCallback');

      it('will not perform any callback', function(){
        expect(controller.didSomething).toBeFalsy();
      });

      itPerformsCallbackForAll(controller);
    });

    describe('when there is one matched callback', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('singleCallback');

      it('will perform the matched callback', function(){
        expect(controller.didSomething).toBeTruthy();
      });

      itPerformsCallbackForAll(controller);
    });

    describe('when there is more than one matched callbacks', function(){
      var controller = new Controller(),
          performer = new Paloma.BeforeCallbackPerformer(controller);

      performer.perform('multiCallback');

      it('will perform all the matched callbacks', function(){
        expect(controller.didSomething && controller.didAnotherThing).
          toBeTruthy();
      });

      itPerformsCallbackForAll(controller);
    });

  });
});
