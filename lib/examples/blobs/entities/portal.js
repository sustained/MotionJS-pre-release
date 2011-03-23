var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
define(['entity', 'geometry/polygon', 'geometry/rectangle'], function(Entity, Polygon, Rectangle) {
  var Portal;
  Portal = (function() {
    __extends(Portal, Entity.Dynamic);
    Portal.prototype.portal = null;
    Portal.prototype.lastUse = 0;
    function Portal() {
      Portal.__super__.constructor.apply(this, arguments);
      this.event.on('collision', function(collision, entity) {
        if (game.Loop.tick - this.lastUse > 0.5) {
          this.lastUse = game.Loop.tick;
          return entity.body.position.copy(this.portal.body.position);
        }
      });
      this.body.shape = Polygon.createRectangle(32, 32);
    }
    Portal.prototype.render = function(context) {
      return this.body.shape.draw(context);
    };
    return Portal;
  })();
  return Portal;
});