define(['motion'], function() {
  var AssetManager;
  AssetManager = (function() {
    AssetManager.build = function(url, ext) {
      if (url.lastIndexOf('.' === -1)) {
        url += '.' + ext;
      }
      if (name.indexOf('://' === -1)) {
        url = this.base + url;
      }
      return [url, ext];
    };
    AssetManager.prototype.base = null;
    AssetManager.prototype.async = true;
    AssetManager.prototype.cache = false;
    AssetManager.prototype.group = 'default';
    AssetManager.prototype.groups = null;
    function AssetManager() {
      this.groups = {};
    }
    AssetManager.prototype.createGroup = function(name) {
      if (this.isGroup(name)) {
        return false;
      }
      return this.groups[name] = {};
    };
    AssetManager.prototype.activeGroup = function(name) {
      if (name == null) {
        name = 'default';
      }
      return this.group = name;
    };
    AssetManager.prototype.removeGroup = function(name) {
      if (name === 'default') {
        return false;
      }
      if (this.isGroup(name)) {
        delete this.groups[name];
      }
      return true;
    };
    AssetManager.prototype.isGroup = function(name) {
      return name in this.groups;
    };
    AssetManager.prototype.load = function() {};
    return AssetManager;
  })();
  return AssetManager;
});