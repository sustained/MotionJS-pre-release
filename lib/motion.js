var Motion, isBrowser;
isBrowser = (typeof window != "undefined" && window !== null) && (typeof document != "undefined" && document !== null) && (typeof navigator != "undefined" && navigator !== null);
Motion = {
  env: isBrowser ? 'client' : 'server',
  root: isBrowser ? window : global,
  version: '0.1'
};
define(['core', 'class', 'classutils', 'hash', 'math/vector'], function(Core, Class, ClassUtils, Hash, Vector) {
  console.log(Core);
  Motion.root.rand = Math.rand;
  Motion.Class = Class;
  Motion.ClassUtils = ClassUtils;
  Motion.Hash = Hash;
  Motion.Vector = Vector;
  return Motion;
});