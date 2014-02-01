import 'package:polymer/polymer.dart';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/websocketprotocol.dart';
import 'dart:html';

@CustomTag("wsfp-rootcomponent")
class WsfpRootComponent extends PolymerElement {
  WsfpRootComponent.created() : super.created() {
    print("hello");
  }
  
  void blahClicked(Event e, var detail, Element target) {
    var fs = new WebSocketFs('127.0.0.1:1234');
    fs.connect().then((e) {
      fs.list("/").then((List<p.File> f) {
        print('got something: ${f}');
      });
    });
  }
}