var server;
var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
  for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
  function ctor() { this.constructor = child; }
  ctor.prototype = parent.prototype;
  child.prototype = new ctor;
  child.__super__ = parent.prototype;
  return child;
};
server = function(Eventful) {
  var Server;
  Server = (function() {
    __extends(Server, Class);
    Server.ReconnectAttempts = 5;
    Server.ReconnectInterval = 10000;
    Server.State = {
      Null: 0,
      Connecting: 1,
      Connected: 2,
      Disconnected: 3,
      Reconnecting: 4,
      Offline: 5
    };
    Server.prototype.opens = 0;
    Server.prototype.closes = 0;
    Server.prototype.attempts = 0;
    Server.prototype.state = Server.State.Null;
    Server.prototype.socket = null;
    Server.prototype.connected = false;
    Server.prototype.autoReconnect = true;
    function Server(host) {
      var i, _i, _len, _ref;
      this.host = host != null ? host : 'ws://localhost:8080/';
      Server.__super__.constructor.call(this);
      this.Event = new Eventful(['connecting', 'connected', 'reconnecting', 'reconnected', 'disconnected', 'offline', 'message'], {
        binding: this
      });
      _ref = ['uuid', 'loginReceived', 'loginSuccess', 'loginFailure'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        this.Event.add("msg." + i);
      }
    }
    Server.prototype.send = function(message, data) {
      return this.socket.send(JSON.stringify([message, data]));
    };
    Server.prototype._onSocketOpen = function() {
      this.opens++;
      this.Event.fire('connected');
      if (this.state === Server.Reconnecting) {
        this.Event.fire('reconnected');
      }
      return this.state = Server.State.Connected;
    };
    Server.prototype._onSocketClose = function() {
      this.closes++;
      this.state = Server.State.Disconnected;
      if (this.closes > this.opens) {
        console.log("Server " + this.host + " appears to be offline.");
      } else {
        console.log("Disconnected from Server " + host);
        this.Event.fire('disconnected');
      }
      if (this.attempts < Server.ReconnectAttempts && this.autoReconnect === true) {
        this.state = Server.State.Reconnecting;
        this.Event.fire('reconnecting');
        return setTimeout(this.method('connect'), Server.ReconnectInterval);
      } else {
        this.state = Server.State.Offline;
        return this.Event.fire('offline');
      }
    };
    Server.prototype._onSocketError = function() {
      return console.log("Server error " + this.host);
    };
    Server.prototype._onSocketMessage = function() {
      var data, json, message;
      try {
        json = JSON.parse(e.data);
      } catch (e) {
        console.error(e);
        return;
      }
      message = parseInt(json[0]);
      data = json[1];
      this.Event.fire('message', [message, data]);
      return this.Event.fire("" + message + "Message", data);
    };
    Server.prototype.createSocket = function() {
      if (this.isSocket()) {
        this.socket.close();
      }
      this.socket = new WebSocket(this.host);
      this.socket.onopen = this.method('_onSocketOpen');
      this.socket.onclose = this.method('_onSocketClose');
      this.socket.onerror = this.method('_onSocketError');
      this.socket.onmessage = this.method('_onSocketMessage');
      return this.socket;
    };
    Server.prototype.connect = function() {
      if (this.state === Server.Connecting || this.state === Server.Connected) {
        return true;
      }
      return this.createSocket();
    };
    Server.prototype.disconnect = function() {
      if (this.isSocket()) {
        return socket.close();
      }
    };
    Server.prototype.isSocket = function() {
      return this.socket instanceof WebSocket;
    };
    Server.prototype.isConnected = function() {
      return this.state === Server.State.Connected;
    };
    Server.prototype.isConnecting = function() {
      return this.state === Server.State.Connecting || this.state === Server.State.Reconnecting;
    };
    return Server;
  })();
  return Server;
};
define(['eventful'], server);