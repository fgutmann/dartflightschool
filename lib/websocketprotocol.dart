import 'protocol.dart' as p;
import 'dart:html';
import 'dart:async';
import 'dart:convert';


class WebSocketFs extends p.Protocol {
  String _server;
  WebSocket _socket;
  
  Completer<List<p.File>> _fileListCompleter;
  
  WebSocketFs(this._server) {
  }
  
  @override
  Future<List<p.File>> list(String path) {
    _fileListCompleter = new Completer<List<p.File>>();
    var data = JSON.encode({'cmd': 'listfiles', 'path': path});
    _socket.send(data);
    return _fileListCompleter.future;
  }

  @override
  Stream<List<int>> open(String path) {
    // TODO: implement open
  }

  @override
  StreamConsumer<List<int>> openWrite(String path) {
    // TODO: implement openWrite
  }

  // TODO: implement protocol
  @override
  String get protocol => 'ws';

  @override
  Future connect() {
    var completer = new Completer();
    _socket = new WebSocket('ws://${_server}/ws');
    _socket.onOpen.listen((Event e) {
      print('onOpen');
      completer.complete();
    }, onError: (e) {
      print("onOpen had an error? ${e}");
    });
    _socket.onError.listen((Event e) {
      print('error while connecting: ${e} ${e.type}');
      completer.completeError(e);
    }, onError: (e) {
      print('onError had an error? ${e}');
    });
    _socket.onMessage.listen((MessageEvent message) {
      print('got message: ${message.data}');
      var msg = JSON.decode(message.data);
      List files = msg['files'];
      List<p.File> ret = files.map((Map<String, dynamic> e) => new p.File(e['name'], e['isDirectory'], e['size'])).toList();
      _fileListCompleter.complete(ret);
      _fileListCompleter = null;
    });
    return completer.future;
  }

  @override
  Future close() {
    return (new Completer()..complete()).future;
  }
}
