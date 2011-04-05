define(['path', 'server/file'], function(path, File) {
  var Directory;
  Directory = (function() {
    Directory.prototype.sync = false;
    Directory.prototype.cache = null;
    Directory.prototype._exists = false;
    Directory.prototype.setup = function() {};
    Directory.prototype.toString = function() {
      return this.dir;
    };
    function Directory(dir) {
      this.setDirectory(dir);
    }
    Directory.prototype.setDirectory = function(dir) {
      if (this._exists = path.existsSync(dir)) {
        if (dir.substr(-1 !== '/')) {
          dir += '/';
        }
        this.dir = dir;
        this.setup();
        this;
      }
      return false;
    };
    Directory.prototype.to = function(dir, morph) {
      if (morph == null) {
        morph = false;
      }
      dir = path.resolve(this.dir, dir);
      console.log("moving from " + this.dir + " to " + dir);
      if (morph) {
        return this.setDirectory(dir);
      } else {
        return new Directory(dir);
      }
    };
    Directory.prototype.up = function(morph) {
      if (morph == null) {
        morph = false;
      }
      return this.to('../', morph);
    };
    Directory.prototype.exists = function() {
      return this._exists;
    };
    Directory.prototype.children = function(options) {};
    Directory.prototype.files = function(options) {
      if (!this.exists()) {
        return false;
      }
      options = $M.extend({
        recursive: false
      }, options);
      return fs.readdirSync(this.dir);
    };
    Directory.prototype.directories = function(options) {};
    return Directory;
  })();
  return Directory;
});
/*
dir = new Directory '~/BlobsGame'

console.log dir
> /Users/Xavura/BlobsGame/

dir.files()
> [
>	'.motiongame'
> ]

dir.directories()
> [
>	'assets/'
>	'config/'
>	'levels/'
>	'lib/'
>	'src/'
> ]

dir.children()
> [
>	'.motiongame'
>	'assets/'
>	'config/'
>	'levels/'
>	'lib/'
>	'src/'
> ]

dir.to('src/entities').files()
> [
>	'player.coffee'
>	'enemy.coffee'
> ]

dir.to('src/entities').files recursive:true
> [
>	'player.coffee'
>	'enemy.coffee'
>	'weapons/grenade.coffee'
>	'weapons/firearm.coffee'
> ]

dir.to('src/entities', true)
console.log dir
> /Users/Xavura/BlobsGame/src/entities/

dir.files extension: '.js'
> []

dir.files(match:/^weapons\/.*$/, fetch:true).each (file) ->
	console.log file, file.contents 'utf8'

> /Users/Xavura/BlobsGame/src/entities/weapons/grenade.coffee
> /Users/Xavura/BlobsGame/src/entities/weapons/firearm.coffee
*/