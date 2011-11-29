path   = require 'path'
{puts} = require 'util'

motionDir = path.normalize path.resolve(__dirname, '../../') + '/'
global._  = require(motionDir + 'vendor/underscore/underscore.min.js');

motion = require(motionDir + 'lib/init.js').motion

global.define = requirejs = require 'requirejs'
requirejs.config motion(motionDir)
