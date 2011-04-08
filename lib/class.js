var __slice = Array.prototype.slice;
define(['classutils'], function(ClassUtils) {
  var BaseClass;
  return BaseClass = (function() {
    var classId;
    classId = 0;
    BaseClass.prototype.id = null;
    function BaseClass() {
      this.id = classId++;
    }
    BaseClass.extend = function(object, overwrite) {
      if (overwrite == null) {
        overwrite = false;
      }
      return Motion.extend(this, object, overwrite);
    };
    BaseClass.include = function(object, overwrite) {
      if (overwrite == null) {
        overwrite = false;
      }
      return Motion.extend(this.prototype, object, overwrite);
    };
    BaseClass.extend(ClassUtils.Ext.Accessors);
    BaseClass.prototype.bind = function(name, bind, args) {
      var _ref;
      if (bind == null) {
        bind = this;
      }
      if (args == null) {
        args = [];
      }
      this[name] = (_ref = this[name]).bind.apply(_ref, [bind].concat(__slice.call(args)));
      return this[name];
    };
    BaseClass.prototype["class"] = function() {
      return this.constructor.name;
    };
    BaseClass.prototype.hash = function() {
      return "<Obj#" + (this["class"]()) + ":" + this.id + ">";
    };
    BaseClass.prototype.toString = BaseClass.prototype.hash;
    BaseClass.prototype.method = function(name, bind) {
      if (bind == null) {
        bind = true;
      }
      if (this[name]) {
        if (bind === true) {
          return this[name].bind(this);
        } else {
          return this[name];
        }
      } else {
        return null;
      }
    };
    BaseClass.prototype.methods = function(opts) {
      var k, methods, v;
      opts = extend({
        self: true,
        bind: true
      }, opts);
      methods = {};
      for (k in this) {
        v = this[k];
        if (!isFunction(v)) {
          continue;
        }
        if (opts.self === true) {
          if (k in this.constructor.__super__) {
            continue;
          }
        } else {
          if (opts.bind === true) {
            v = v.bind(this);
          }
        }
        methods[k] = v;
      }
      return methods;
    };
    BaseClass.prototype.respondTo = function(method) {
      return method in this;
    };
    BaseClass.prototype.send = function() {
      var args, method;
      method = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return this[method].apply(this, args);
    };
    return BaseClass;
  })();
});