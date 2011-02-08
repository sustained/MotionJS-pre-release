var LoginController, LoginMainState, controller;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
controller = function() {
  var Controller;
  Controller = (function() {
    __extends(Controller, Class);
    function Controller(Game) {
      Controller.__super__.constructor.call(this);
      this.Game = Game;
    }
    Controller.prototype.before = function() {};
    Controller.prototype.after = function() {};
    Controller.prototype.update = function(tick, delta) {};
    Controller.prototype.render = function(context) {};
    return Controller;
  })();
  return Controller;
};
define(function() {
  return controller;
});
LoginController = (function() {
  __extends(LoginController, Controller);
  function LoginController(Game) {
    LoginController.__super__.constructor.call(this, Game);
    this.state = 'default';
    this.Message = new MessageQueue;
    this.Message.subscribeTo(this.Game.Server);
  }
  LoginController.prototype.states = {
    "default": {
      update: function(tick, delta) {},
      render: function(context) {}
    }
  };
  LoginController.prototype.before = function() {
    this.loadView('login');
    return this.Game.Server.connect();
  };
  return LoginController;
})();
LoginMainState = (function() {
  function LoginMainState() {
    LoginMainState.__super__.constructor.apply(this, arguments);
  }
  __extends(LoginMainState, State);
  LoginMainState.prototype.update = function(tick, delta) {
    if (this.Message.get('Server:connect')) {
      return null;
    } else if (this.Message.get('Server:disconnect')) {
      return null;
    }
  };
  LoginMainState.prototype.render = function(context) {};
  return LoginMainState;
})();