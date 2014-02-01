import 'dart:io';

void main() {
  print("Hello, World!");
  String host = '127.0.0.1';
  int port = 1234;
  HttpServer.bind('127.0.0.1', port).then((HttpServer server) {
    print("We bound our server.");
    server.listen((HttpRequest req) {
      print("got a request!");
      if (req.uri.path == '/ws') {
        WebSocketTransformer.upgrade(req).then((WebSocket socket) {
          socket.listen((message) {
            print("got a message: ${message}");
          });
        });
      }
    });
  });
}