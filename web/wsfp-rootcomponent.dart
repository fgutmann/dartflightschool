import 'package:polymer/polymer.dart';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/websocketprotocol.dart';

@CustomTag("wsfp-rootcomponent")
class WsfpRootComponent extends PolymerElement {
  WsfpRootComponent.created() : super.created() {
    print("hello");
    var fs = new WebSocketFs('ws://127.0.0.1:1234/ws');
    fs.list("/").then((List<p.File> f) {
      print('got something.');
    });
  }
}