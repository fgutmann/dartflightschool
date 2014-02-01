import 'dart:io';
import 'dart:convert';

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
            var data = JSON.decode(message);
            var cmd = data['cmd'];
            if (cmd == 'listfiles') {
              var path = data['path'];
              var dir = new Directory("./${path}");
              print("dir: ${dir} // path: ${path}");
              
              List<FileSystemEntity> list = dir.listSync(recursive: false);
              print("file list: ${list}");
              Map response = {};
              response['files'] = list.map((e) => { 'path': e.path, 'isDirectory': e is Directory, 'size': e.statSync().size }).toList();
              socket.add(JSON.encode(response));
            }
          });
        });
      } else if (req.uri.path == '/list') {
        
      }
    });
  });
}