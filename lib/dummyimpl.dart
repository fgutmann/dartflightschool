import 'protocol.dart';
import 'dart:async';

class DummyStreamConsumer extends StreamConsumer<List<int>> {
  DummyFs fs;
  File editFile;
  
  DummyStreamConsumer(this.fs, this.editFile) {
  }
  
  @override
  Future addStream(Stream<List<int>> stream) {
    List<int> content = fs.datafiles[editFile];
    stream.listen((List<int> data) {
      content.addAll(data);
    });
  }

  @override
  Future close() {
  }
}

class DummyFs extends Protocol {
  
  List<File> myfiles = [
                        new File("blubb", false, 3),
                        new File("test1", false, 3),
                        new File("test2", false, 3),
                        ];
  
  Map<File, List<int>> datafiles = {};
  
  @override
  Future<List<File>> list(String path) {
    var completer = new Completer<List<File>>();
    completer.complete(myfiles);
    return completer.future;
  }
  
  File getFileByPath(String path) {
    return myfiles.firstWhere((e) => e.name == path);
  }

  @override
  Stream<List<int>> open(String path) {
    var f = getFileByPath(path);
    List<int> data = datafiles[f];
    return new Stream.fromIterable([data]);
  }
  

  @override
  StreamConsumer<List<int>> openWrite(String path) {
    var f = new File(path, false, 3);
    myfiles.add(f);
    return new DummyStreamConsumer(this, f);
  }

  @override
  String get protocol => "dummy";
}