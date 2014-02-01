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
  /**
   *  List the files and directories at the given path.
   *  Returns null if the given path is not a readable directory.
   */
  List<File> list(String path);
  
  /**
   * Opens the given path for writing.
   */
  // TODO: change type of IOSink, must be stream or something other
  // IOSink is defined in dart:io which won't work in browsers
  EventSink openWrite(String path);
  
  /**
   * Opens the given path for reading.
   */
  Stream<List<int>> open(String path);
}