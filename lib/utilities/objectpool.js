define(function() {
  var ObjectPool;
  ObjectPool = (function() {
    ObjectPool.prototype.pool = null;
    function ObjectPool() {
      this.pool = {};
    }
    ObjectPool.prototype.create = function() {};
    ObjectPool.prototype.destroy = function() {};
    return ObjectPool;
  })();
  return ObjectPool;
});