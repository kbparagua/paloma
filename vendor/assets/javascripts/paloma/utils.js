Paloma.utils = {

  merge: function(target, source){
    for (var k in source)
      if (source.hasOwnProperty(k))
        target[k] = source[k];
  }

};
