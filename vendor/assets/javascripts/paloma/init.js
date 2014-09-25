window.Paloma = window.Paloma || {};

//
// Do nothing if there is no available console.
//
if ( !window['console'] ){
  Paloma.log = Paloma.warn = function(msg){};
}
else {
  Paloma.warn = function(msg){
    if (Paloma.env != 'development'){ return; }
    console.warn(msg);
  };

  Paloma.log = function(msg){
    if (Paloma.env != 'development'){ return; }
    console.log(msg);
  };
}

$(document).ready(function(){
  // Do not continue if Paloma not found.
  if (window['Paloma'] === undefined) {
    if (window['console'] !== undefined) {
      console.warn("Paloma not found. Require it in your application.js.");
    }
    return true;
  }

  Paloma.engine.start();
});