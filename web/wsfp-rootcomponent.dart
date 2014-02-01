import 'package:polymer/polymer.dart';
import 'package:dartflightschool/protocol.dart' as p;
import 'package:dartflightschool/websocketprotocol.dart';

@CustomTag("wsfp-rootcomponent")
class WsfpRootComponent extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  WsfpRootComponent.created() : super.created() {

  }
}