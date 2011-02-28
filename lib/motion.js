define(function() {
  var Motion, isBrowser;
  isBrowser = (typeof window != "undefined" && window !== null) && (typeof document != "undefined" && document !== null) && (typeof navigator != "undefined" && navigator !== null);
  Motion = {
    isBrowser: function() {
      return isBrowser;
    },
    env: isBrowser ? 'client' : 'server',
    root: isBrowser ? window : global,
    version: '0.1'
  };
  return Motion;
});