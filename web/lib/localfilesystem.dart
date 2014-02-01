import 'protocol.dart';
import 'dart:html' show window, FileSystem, FileEntry, FileWriter, Blob, DirectoryEntry;
import 'dart:async';


final int size = 1024 * 1024;
final bool persistent = true;

class FileSystemAccess extends Protocol {
  List<File> list(String path) {
    window.navigator.persistentStorage.requestQuota(size);
    window.requestFileSystem(size, persistent: persistent).then((fs){
      List<File> files = new List<File>();
      DirectoryEntry root = fs.root;
      root.createReader().readEntries().then((entries){
        entries.forEach((entry){
          File file = new File(entry.name, entry.isDirectory, 0);
          files.add(file);
        });
      });
      return files;
    });
    //return new List<File>()..add(new File("Error opening local file store", false, 0));
  }

  Stream<List<int>> open(String path) {
    // TODO: implement open
  }

  StreamConsumer openWrite(String path) {
    return new FileSystemAccessStreamSink(path);
  }
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
        }, onError: errorHandling);
      });
    });
    return completer.future;
  }

  Future close() {
    return;
  }

}

errorHandling(e) {
  print("error");
}

class FileSystemAccessFile extends File {
  FileSystemAccessFile(String name, bool isDirectory, int size) : super(name, isDirectory, size);
}