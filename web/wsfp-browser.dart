import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/dummyimpl.dart'; 

class UrlData {
  String protocol;
  String server;
  String path;
  
  UrlData(this.protocol, this.server, this.path);
  
  UrlData.fromString(String url) {
    var regex = new RegExp('([^:]+)://([^/]*)/(.*)');
    var match = regex.matchAsPrefix(url);
    if(match == null) {
      throw new Exception("Not a valid url");
    }
    
    protocol = match.group(1);
    server = match.group(2);
    path = match.group(3);
  }
}

@CustomTag("wsfp-browser")
class WsfpBrowser extends PolymerElement {

  bool get applyAuthorStyles => true;

  @observable
  String url;

  @observable
  List<p.File> currentFiles = new List();

  /// the current protocol id
  String currentProtocolId;
  
  /// the currently closed 
  p.Protocol currentProtocol;
  
  /// initialization logic
  WsfpBrowser.created() : super.created() {
    currentFiles.add(new p.File("test", true, 1));
  }
  
  enteredView() {
    super.enteredView();
    
    $['wsfp-url'].onKeyPress.listen((KeyboardEvent event) {
      if(event.keyCode == 13) {
        try {
          var urlData = new UrlData.fromString(url);
          var protocol = getProtocol(urlData);
          if(protocol == null) {
            this.url = 'unsupported protocol ' + urlData.protocol;
          } else {
            list(protocol, urlData.path);
          }
        } catch (Exception) {
          this.url = 'invalid url';
        }
      }
    });    
  }
  
  /**
   * Parses the url and returns protocol and path.
   * If the url is not well-formed or the protocol is not found this returns null.
   */
  p.Protocol getProtocol(UrlData url) {
    var protocolId = url.protocol + "_" + url.server;
    
    if(currentProtocolId == protocolId) {
      return currentProtocol;
    }
    
    if (currentProtocol != null) { 
      currentProtocol.close();
    }
    currentProtocolId = protocolId;
    
    switch(url.protocol) {
      case "dummy":
         currentProtocol = new DummyFs();
         break;
    }
    
    return currentProtocol;
  }
  
  void list(p.Protocol protocol, String path) {
    protocol.list(path).then((files) {
      this.currentFiles = files;
    });
  }
}