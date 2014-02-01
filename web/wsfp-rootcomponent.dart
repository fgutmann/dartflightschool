import 'package:polymer/polymer.dart';

@CustomTag("wsfp-rootcomponent")
class WsfpRootComponent extends PolymerElement {
  WsfpRootComponent.created() : super.created() {
    print("hello");
  }
}