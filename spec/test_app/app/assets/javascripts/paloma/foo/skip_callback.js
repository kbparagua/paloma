Paloma.callbacks['foo']['skip_callback'] = function(params)
{
  // Must not reach this code.
  window.callback = "foo/skip_callback";
  window.params = params;
};
