var client;
client = function(Eventful) {
  var Client;
  Client = (function() {
    function Client(connection, server) {
      this.connection = connection;
      this.server = server;
      this.id = connection.sessionId;
      this.Event = new Eventful(['message', 'close', 'rejected'], {
        binding: this
      });
      connection.addListener('message', function(data) {
        return console.log(data);
      });
      connection.addListener('disconnect', function() {
        return console.log("Client " + this.id + " disconnected");
      });
    }
    Client.prototype.send = function(command, data) {
      return this.client.send([command, data]);
    };
    return Client;
  })();
  return Client;
};
define(['eventful'], client);