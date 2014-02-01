import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/dummyimpl.dart'; 

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
  WsfpBrowser.created() : super.created() {}
  
  enteredView() {
    super.enteredView();
    
    $['wsfp-url'].onKeyPress.listen((KeyboardEvent event) {
      if(event.keyCode == 13) {
        list(parse(url));
      }
    });    
  }
  
  /**
   * Parses the url and returns protocol and path.
   * If the url is not well-formed or the protocol is not found this returns null.
   */
  p.Protocol getProcotol(String url) {
    var regex = new RegExp('([^:]+)://([^/]*)/(.*)');
    var match = regex.matchAsPrefix(url);
    if(match == null) {
      return null;
    }
    
    var type = match.group(1);
    var host = match.group(2);
    var path = match.group(3);
    
    var protocolId = type + "_" + host;
    
    if(currentProtocolId == protocolId) {
      return currentProtocol;
    }
    
    if (currentProtocol != null) { 
      currentProtocol.close();
    }
    currentProtocolId = protocolId;
    
    switch(type) {
      case "dummy":
         currentProtocol = new DummyFs();
    }
  }
  
  void list(p.Protocol protocol, String path) {
    
  }
}