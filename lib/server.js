var run;
run = function(Motion, http, Server) {
  var server, wss;
  server = http.createServer(function(request, response) {
    response.writeHead(200, {
      'Content-Type': 'text/html'
    });
    return response.end('<h1>Hello World</h1>');
  });
  server.listen(8080);
  wss = new Server;
  return wss.attach(server);
};
require(['motion', 'http', 'server/websocketserver'], run);