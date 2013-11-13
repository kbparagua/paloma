window.Paloma = window.Paloma || {};

//
// Do nothing if there is no available console.
//
if (!window['console']){ Paloma.log = function(msg){}; }
else {
  Paloma.log = function(msg){
    if (Paloma.env != 'development'){ return true; }
    console.log(msg);
  };
}
