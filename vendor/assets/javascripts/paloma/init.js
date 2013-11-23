window.Paloma = window.Paloma || {};

//
// Do nothing if there is no available console.
//
if (!window['console'] || Paloma.env != 'development'){ Paloma.log = Paloma.warn = function(msg){}; }
else {
  Paloma.warn = function(msg){
    console.warn(msg);
  };

  Paloma.log = function(msg){
    console.log(msg);
  };
}
