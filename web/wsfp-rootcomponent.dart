import 'package:polymer/polymer.dart';

@CustomTag("wsfp-rootcomponent")
class WsfpRootComponent extends PolymerElement {
  
  bool get applyAuthorStyles => true;
  
  WsfpRootComponent.created() : super.created() {
    print("hello");
  }
}