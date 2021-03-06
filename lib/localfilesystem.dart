library localfilesystem;

import 'protocol.dart';
import 'dart:html' show window, FileSystem, FileEntry, FileWriter, Blob, DirectoryEntry;
import 'dart:async';


final int size = 1024 * 1024;
final bool persistent = true;

class FileSystemAccess extends Protocol {
  Future<List<File>> list(String path) {
    var completer = new Completer();
    window.requestFileSystem(size, persistent: persistent).then((fs){
      List<File> files = new List<File>();
      DirectoryEntry root = fs.root;
      root.createReader().readEntries().then((entries){
        entries.forEach((entry){
          File file = new File(entry.name, entry.isDirectory, 0);
          files.add(file);
        });
        completer.complete(files);
      });
    });
    return completer.future;
  }

  Future<Stream<List<int>>> open(String path) {
    FileSystem fileSystem;
    window.requestFileSystem(size, persistent: persistent).then((fs){
      fileSystem = fs;
    });
//    while(fileSystem == null) {
//    }
//    return fs.root.getFile(path).asStream();
    return null;
  }

  Future<StreamConsumer> openWrite(String path) {
    return null;//new FileSystemAccessStreamSink(path);
  }

  Future close() {
    return (new Completer()..complete()).future;
  }

  Future connect() {
    //on connect request quota from browser
    window.navigator.persistentStorage.requestQuota(size);
    return (new Completer()..complete()).future;
  }

  String get protocol => "localfile";
}

class FileSystemAccessStreamSink extends StreamConsumer<List<int>> {

  String path;

  FileSystemAccessStreamSink(this.path) {}
  
  Future addStream(Stream<List<int>> stream) {
    var completer = new Completer();
    window.requestFileSystem(size, persistent: persistent).then((fs){
      fs.root.createFile(path).then((file){
        (file as FileEntry).createWriter().then((FileWriter writer){
          stream.toList().then((data) {
            String value = new String.fromCharCodes(data);
            writer.write(new Blob([value]));
            writer.onError.listen((error){
              print(error);
            });
            writer.onWriteEnd.listen((end){
              print("Completed write.");
            });
            completer.complete();
          });
        });
      });
    });
    return completer.future;
  }

  Future close() {
    return (new Completer()..complete()).future;
  }

}

class FileSystemAccessFile extends File {
  FileSystemAccessFile(String name, bool isDirectory, int size) : super(name, isDirectory, size);
}