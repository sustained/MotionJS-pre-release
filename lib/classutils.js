define(['core'], function() {
  var ClassUtils;
  ClassUtils = {
    Inc: {},
    Ext: {
      Aliasing: {
        alias: function(aliases, method) {
          var i, _i, _len, _results;
          if (isArray(aliases)) {
            _results = [];
            for (_i = 0, _len = aliases.length; _i < _len; _i++) {
              i = aliases[_i];
              _results.push(this.prototype[i] = method);
            }
            return _results;
          } else {
            return this.prototype[aliases] = method;
          }
        }
      },
      Accessors: {
        set: function(name, set, options) {
          if (options == null) {
            options = {};
          }
          options = extend({
            enumerable: true,
            configurable: true
          }, options);
          return Object.defineProperty(this.prototype, name, extend(options, {
            set: set
          }));
        },
        get: function(name, get, options) {
          if (options == null) {
            options = {};
          }
          options = extend({
            enumerable: true,
            configurable: true
          }, options);
          return Object.defineProperty(this.prototype, name, extend(options, {
            get: get
          }));
        }
      }
    }
  };
  return ClassUtils;
});