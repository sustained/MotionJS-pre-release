var queue;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
queue = function(Eventful) {
  var Queue;
  Queue = (function() {
    Queue.messages = {};
    function Queue() {}
    Queue.prototype.subscribe = function(ident, eventful) {
      var event, _i, _len, _ref;
      if (!eventful instanceof Eventful) {
        if ('Event' in eventful) {
          eventful = eventful.Event;
        } else {
          return false;
        }
      }
      if (!ident in this.messages) {
        this.messages[ident] = [];
      }
      _ref = eventful.eventNames;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        eventful.on(event, (__bind(function() {
          return this.messages[eventful.hash()] = Array.prototype.slice.call(arguments);
        }, this)), {
          once: true
        });
      }
    };
    Queue.prototype.get = function(message) {
      var event, ident, _ref;
      _ref = message.split(':'), ident = _ref[0], event = _ref[1];
      if (this.messages[ident] && this.messages[ident][event]) {
        message = this.messages[ident][event];
        delete this.messages[ident][event];
        return message;
      }
    };
    return Queue;
  })();
  return Queue;
};
define(['eventful'], function() {
  return queue;
});