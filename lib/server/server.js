var __indexOf = Array.prototype.indexOf || function(item) {
  for (var i = 0, l = this.length; i < l; i++) {
    if (this[i] === item) return i;
  }
  return -1;
};
define(['socket.io', 'server/client'], function(io, Client) {
  var Server, http;
  http = require('http');
  /*

  	*/
  Server = (function() {
    Server.prototype.port = null;
    Server.prototype.socket = null;
    Server.prototype.clients = null;
    function Server(port) {
      this.port = port != null ? port : 8080;
      this.clients = {};
    }
    Server.prototype.attach = function(httpServer) {
      if (!httpServer instanceof http.Server) {
        if (!isNumber(this.port)) {
          return false;
        }
        httpServer = http.createServer(function(request, response) {});
        httpServer.listen(this.port);
      }
      this.server = io.listen(httpServer, {
        transports: ['websocket', 'flashsocket', 'xhr-multipart', 'xhr-polling', 'jsonp-polling']
      });
      this.server.on('connection', function(client) {
        return this.clients[client.sessionId] = new Client(client, this);
      });
      return true;
    };
    Server.prototype.send = function(id, message) {
      if (__indexOf.call(this.clients, id) >= 0) {
        return this.clients[id].send(message);
      }
    };
    Server.prototype.broadcast = function(message, except) {
      return this.server.broadcast(message, except);
    };
    return Server;
  })();
  return Server;
});