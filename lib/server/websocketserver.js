var server;
server = function(io, Client) {
  var Server;
  Server = (function() {
    Server.prototype.clients = null;
    function Server() {
      this.clients = {};
    }
    Server.prototype.attach = function(httpServer) {
      if (!httpServer instanceof http.Server) {
        return false;
      }
      this.socket = io.listen(httpServer);
      this.socket.on('connection', function(client) {
        console.log("(WebSocket) Client " + client + " connected");
        return this.clients[client.sessionId] = new Client(client, this);
      });
      return true;
    };
    Server.prototype.send = function(id, command, data) {
      if (data == null) {
        data = {};
      }
      return this.server.send(id, JSON.stringify([command, data]));
    };
    Server.broadcast = Server.prototype.send;
    return Server;
  })();
  return Server;
};
define(['socket.io', 'server/websocketclient'], server);