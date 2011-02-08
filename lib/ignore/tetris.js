var run;
run = function(Motion, Game) {
  var game;
  return game = Motion.root().game = new Game;
};
require({
  baseUrl: require('path').normalize(__dirname + '../../')
}, ['motion', 'client/game'], run);
/*

■ ■
■ ■

■
■ ■ ■

    ■
■ ■ ■

■ ■ ■ ■

  ■ ■
■ ■

■ ■
  ■ ■

  ■
■ ■ ■

*/