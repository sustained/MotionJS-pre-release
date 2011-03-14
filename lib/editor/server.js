require(['fs', 'sys', 'http', 'socket.io'], function(fs, sys, http, io) {
  var motionPath, motionUrl, server, socket;
  motionUrl = 'http://localhost:80/Shared/JavaScript/MotionJS/';
  motionPath = '/Library/WebServer/Documents/Shared/JavaScript/MotionJS/';
  server = http.createServer();
  server.listen(8080);
  socket = io.listen(server);
  return socket.on('connection', function(client) {
    console.log("server got client " + client);
    client.on('message', function(message) {
      return console.log("message " + message + " from " + client);
    });
    return client.on('disconnect', function() {
      return console.log("client " + client + " disconnected");
    });
  });
});