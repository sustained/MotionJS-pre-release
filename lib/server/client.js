var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
define(['eventful'], function(Eventful) {
  var Client;
  Client = (function() {
    Client.prototype.log = function(message) {
      return console.log("Client #" + this.id + ": " + message);
    };
    function Client(connection, server) {
      this.connection = connection;
      this.server = server;
      this.id = connection.sessionId;
      this.event = new Eventful(['message', 'close', 'rejected'], {
        binding: this
      });
      this.log('connected');
      connection.addListener('message', __bind(function(message) {
        return this.log("message: " + message);
      }, this));
      connection.addListener('disconnect', __bind(function() {
        return this.log('disconnected');
      }, this));
    }
    Client.prototype.send = function(message) {
      return this.connection.send(message);
    };
    Client.prototype.broadcast = function(message) {
      return this.connection.broadcast(message);
    };
    Client.prototype.isConnected = function() {
      return this.connection.connected;
    };
    return Client;
  })();
  return Client;
});