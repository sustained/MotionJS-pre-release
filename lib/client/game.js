var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['motion', 'eventful', 'stateful', 'loop', 'input', 'screenmanager', 'screen', 'canvas', 'colour'], function(Motion, Eventful, Stateful, Loop, Input, MScreen, Screen, Canvas, Colour) {
  var Game;
  Motion = extend(Motion, {
    Eventful: Eventful,
    Stateful: Stateful,
    Loop: Loop,
    Input: Input,
    MScreen: MScreen,
    Screen: Screen,
    Canvas: Canvas,
    Colour: Colour
  });
  Game = (function() {
    __extends(Game, Motion.Class);
    function Game() {
      Game.__super__.constructor.call(this);
      if (Motion.env === 'client') {
        this.Input = new Input;
        this.Screen = new MScreen(this);
      }
      this.Loop = new Loop(this);
      this.E = this.Event = new Eventful;
    }
    return Game;
  })();
  return Game;
});