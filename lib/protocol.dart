library wsfp.abc;

import 'dart:async';


class File {
  /// The name of the file or directory
  String name;
  
  /// Filesize in bytes or number of subfiles/directories if it is a directory.
  int size;
  
  /// If the file is a directory or file
  bool isDirectory;
  
  File(this.name, this.isDirectory, this.size);
}

abstract class Protocol {
  
  /// return the protocol prefix - e.g. file for file:// or ws for ws://
  String get protocol;
  
  Future connect();
  
  /**
   *  List the files and directories at the given path.
   *  Returns null if the given path is not a readable directory.
   */
  Future<List<File>> list(String path);
  
  /**
   * Opens the given path for writing.
   */
  Future<StreamConsumer<List<int>>> openWrite(String path);
  
  /**
   * Opens the given path for reading.
   */
  Future<Stream<List<int>>> open(String path);
  
  Future close();
}