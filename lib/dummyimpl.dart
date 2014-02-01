import 'protocol.dart';
import 'dart:async';


class DummyFs extends Protocol {
  
  @override
  List<File> list(String path) {
    return [
            new File("blubb", false, 3),
            new File("test1", false, 3),
            new File("test2", false, 3),
            ];
  }

  @override
  Stream<List<int>> open(String path) {
    return null;
  }

  @override
  StreamSink openWrite(String path) {
    return null;
  }
}