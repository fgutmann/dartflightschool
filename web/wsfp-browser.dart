import 'package:polymer/polymer.dart';
import 'dart:html';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/dummyimpl.dart' as dummy;
import 'dart:async';
import 'package:dartflightschool/localfilesystem.dart' as lfs;
import 'package:dartflightschool/websocketprotocol.dart';
import 'package:dartflightschool/urldata.dart';

@CustomTag("wsfp-browser")
class WsfpBrowser extends PolymerElement {

  bool get applyAuthorStyles => true;

  @observable
  String url = "dummy:///";

  @observable
  List<p.File> currentFiles = new List();

  /// the current protocol id
  String currentProtocolId;
  
  /// the currently closed 
  Future<p.Protocol> currentProtocol;
  
  /// initialization logic
  WsfpBrowser.created() : super.created() {}
  
  enteredView() {
    super.enteredView();
    
    $['wsfp-url'].onKeyPress.listen((KeyboardEvent event) {
      if(event.keyCode == 13) {
        updateView();
      }
    });
  }
  
  onDirectoryClick(Event e, var detail, Element target) {
     var name = target.attributes["data-name"];
     if(name == "..") {
       url = (url.split('/')..removeLast()).join("/") + "/";
     } else {
       url += (name + '/');       
     }
     
     if(url.endsWith("/")) {
       url = url.substring(0, url.length -1);
     }
     
     updateView();
  }
  
  updateView() {
    try {
      var urlData = new UrlData.fromString(url);
      var protocol = getProtocol(urlData);
      if(protocol == null) {
        this.url = 'unsupported protocol ' + urlData.protocol;
      } else {
        protocol.then((p) {
          list(p, urlData.path);          
        });
      }
    } catch (Exception) {
      this.url = 'invalid url';
    }
  }
  
  void list(p.Protocol protocol, String path) {
    protocol.list(path).then((files) {
      var newFiles = new List<p.File>();
      
      if(new UrlData.fromString(url).path != "") {
        newFiles.add(new p.File("..", true, 0));
      }
      newFiles.addAll(files);
      this.currentFiles = newFiles;
    });
  }
  
  
  /**
   * Parses the url and returns protocol and path.
   * If the url is not well-formed or the protocol is not found this returns null.
   */
  Future<p.Protocol> getProtocol(UrlData url) {
    var protocolId = url.protocol + "_" + url.server;
    
    if(currentProtocolId == protocolId) {
      return currentProtocol;
    }
    
    if (currentProtocol != null) { 
      currentProtocol.then((protocol) {
        protocol.close();
      });
    }
    currentProtocolId = protocolId;
    
    p.Protocol newProtocol;
    
    switch(url.protocol) {
      case "dummy":
        newProtocol = new dummy.DummyFs();
        break;
      case "localfile":
        newProtocol = new lfs.FileSystemAccess();
        break;
      case "wsfp":
        newProtocol = new WebSocketFs(url.server);
    }
    
    Completer<p.Protocol> connectedProtocol = new Completer();
    newProtocol.connect().then((e) {
      connectedProtocol.complete(newProtocol);
    });
    currentProtocol = connectedProtocol.future;
    return connectedProtocol.future;
  }
}