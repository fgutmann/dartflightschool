import 'protocol.dart';
import 'dart:async';


class DummyFs extends Protocol {
  
  List<File> myfiles = [
                        new File("blubb", false, 3),
                        new File("test1", false, 3),
                        new File("test2", false, 3),
                        ];
  
  @override
  Future<List<File>> list(String path) {
    var completer = new Completer<List<File>>();
    completer.complete(myfiles);
    return completer.future;
  }

  @override
  Stream<List<int>> open(String path) {
    return null;
  }

  @override
  StreamSink openWrite(String path) {
    return null;
  }

  @override
  String get protocol => "dummy";
}