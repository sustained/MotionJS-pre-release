define(function() {
  var Eventful;
  return Eventful = (function() {
    Eventful.prototype.binding = null;
    Eventful.prototype.runOnce = null;
    Eventful.prototype.aliases = false;
    Eventful.prototype.group = 'default';
    function Eventful(events, options) {
      var _ref;
      if (options == null) {
        options = {};
      }
      if ((events != null) && !isArray(events)) {
        events = Array.prototype.slice.call(arguments);
        options = isObject(events.last()) ? events.pop() : {};
      }
      this.binding = (_ref = options.binding) != null ? _ref : null;
      this.events = {};
      this.groups = {
        "default": true
      };
      this.eventNames = [];
      this.groupNames = [];
      if (isArray(events)) {
        this.add(events);
      }
    }
    Eventful.prototype.createGroup = function(name, enable) {
      if (enable == null) {
        enable = false;
      }
      if (!isString(name && 'hash' in name)) {
        name = name.hash();
      }
      if (!this.isGroup(name)) {
        this.groups[name] = enable;
        return this.groupNames.push(name);
      }
    };
    Eventful.prototype.isEvent = function(name) {
      return this.events.hasOwnProperty(name);
    };
    Eventful.prototype.hashKey = function(key) {};
    Eventful.prototype.openGroup = function(name) {
      if (!isString(name && 'hash' in name)) {
        return name = name.hash();
      }
    };
    Eventful.prototype.closeGroup = function() {
      this.group = 'default';
      return this;
    };
    Eventful.prototype.enableGroup = function(name) {
      if (this.isGroup(name)) {
        return this.groups[name] = true;
      }
    };
    Eventful.prototype.disableGroup = function(name) {
      if (name === 'default') {
        return false;
      }
      if (this.isGroup(name)) {
        return this.groups[name] = false;
      }
    };
    Eventful.prototype.isGroup = function(name) {
      return this.groups.hasOwnProperty(name);
    };
    Eventful.prototype.on = function(name, callback, options) {
      var _ref, _ref2, _ref3, _ref4;
      if (options == null) {
        options = {};
      }
      if (!this.isEvent(name)) {
        this.add(name);
      }
      if (!isFunction(callback)) {
        return false;
      }
      this.events[name].push({
        call: callback,
        args: (_ref = options.args) != null ? _ref : [],
        bind: (_ref2 = options.bind) != null ? _ref2 : this.binding,
        once: (_ref3 = options.once) != null ? _ref3 : this.runOnce,
        when: (_ref4 = options.when) != null ? _ref4 : true,
        group: this.group
      });
      return this;
    };
    Eventful.prototype.add = function(name, createAliases) {
      var i, _i, _len;
      if (createAliases == null) {
        createAliases = false;
      }
      if (isArray(name)) {
        for (_i = 0, _len = name.length; _i < _len; _i++) {
          i = name[_i];
          this.add(i);
        }
      } else if (name != null) {
        if (this.isEvent(name)) {
          return false;
        }
        this.events[name] = [];
        this.eventNames.push(name);
        if (this.aliases || createAliases === true) {
          this.createAliases(name);
        }
      }
      return this;
    };
    Eventful.prototype.createAliases = function(name) {
      var alias;
      alias = name.replace(/_/g, ' ').capitalize().replace(/\s/g, '');
      this['on' + alias] = function(callback, options) {
        return this.on(name, callback, options);
      };
      this['fire' + alias] = function(args) {
        return this.fire(name, args);
      };
      this['clear' + alias] = function(remove) {
        return this.clear(name, remove);
      };
      return this['remove' + alias] = function() {
        return this.remove(name);
      };
    };
    Eventful.prototype.deleteAliases = function(name) {
      var alias;
      alias = name.capitalize().replace('_', '');
      delete this['on' + alias];
      delete this['fire' + alias];
      delete this['clear' + alias];
      return delete this['remove' + alias];
    };
    Eventful.prototype.remove = function(name) {
      if (this.isEvent(name)) {
        this.clear(name, true);
        if (this.aliases === true) {
          return this.deleteAliases(name);
        }
      }
    };
    Eventful.prototype.fire = function(name, args) {
      var callback, _i, _len, _ref, _results;
      if (args == null) {
        args = [];
      }
      if (!this.isEvent(name)) {
        return false;
      }
      _ref = this.events[name];
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        callback = _ref[_i];
        if (this.groups[callback.group] === false) {
          continue;
        }
        callback.call.apply(callback.bind, callback.args.concat(args));
        _results.push(callback.once === true ? this.removeCallback(name, _i) : void 0);
      }
      return _results;
    };
    Eventful.prototype.clear = function(name, remove) {
      if (remove == null) {
        remove = false;
      }
      if (this.isEvent(name)) {
        this.events[name] = [];
        if (remove === true) {
          return delete this.events[name];
        }
      }
    };
    Eventful.prototype.removeCallback = function(name, id) {
      if (this.isEvent(name && this.events[name][id])) {
        return this.events[name].splice(id, 1);
      }
    };
    return Eventful;
  })();
});