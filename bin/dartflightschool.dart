import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as path;

void main() {
  print("Hello, World!");
  String host = '0.0.0.0';
  int port = 1234;
  HttpServer.bind(host, port).then((HttpServer server) {
    print("We bound our server.");
    server.listen((HttpRequest req) {
      print("got a request!");
      if (req.uri.path == '/ws') {
        
        WebSocketTransformer.upgrade(req).then((WebSocket socket) {
          socket.listen((message) {
            print("got a message: ${message}");
            var data = JSON.decode(message);
            var cmd = data['cmd'];
            var basepath = '..';
            if (cmd == 'listfiles') {
              var filepath = data['path'];
              var dir = new Directory("${basepath}${filepath}");
              print("dir: ${dir} // path: ${filepath}");
              
              List<FileSystemEntity> list = dir.listSync(recursive: false);
              print("file list: ${list}");
              Map response = {};
              response['files'] = list.map((e) => { 'path': e.path, 'name': path.basename(e.path), 'isDirectory': e is Directory, 'size': e.statSync().size }).toList();
              socket.add(JSON.encode(response));
            } else if (cmd == 'read') {
              var path = data['path'];
              File f = new File("${basepath}${path}");
              Map response = {'content': f.readAsStringSync()};
              socket.add(JSON.encode(response));
            }
          });
        });
      } else if (req.uri.path == '/list') {
        
      }
    });
  });
}