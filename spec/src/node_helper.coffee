path = require 'path'
motionDir = path.normalize path.resolve(__dirname, '../../') + '/'
global._ = require(motionDir + 'vendor/underscore/underscore.min.js');
require(motionDir + 'lib/init.js');
requirejs = require 'requirejs'
rjsConfig = global.motion motionDir
requirejs.config rjsConfig
global.define = requirejs
