import 'dart:html';
import 'dart:async';
import 'lib/localfilesystem.dart';

void main() {
  FileSystemAccess system = new FileSystemAccess();
  listElements(system);
  List<int> bytes = [116,101,115,116];
  Stream<List<int>> stream = new Stream.fromIterable(bytes);
  stream.pipe(system.openWrite('test.txt')).then((success){
    listElements(system);
  });
}

void listElements(system) {
  querySelector("#list").children.clear();
  system.list("/").forEach((element) {
    UListElement list = querySelector("#list");
    list.append(new LIElement()..appendText(element.name));
  });
}

