import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag("wsfp-browser")
class WsfpBrowser extends PolymerElement {
  
  @observable
  String url;
  
  WsfpBrowser.created() : super.created() {
    print("hello");
  }
  
  enteredView() {
    super.enteredView();
    print("hello2");
    print($['wsfp-url']);
    
    $['wsfp-url'].onKeyPress.listen((KeyboardEvent event) {
      if(event.keyCode == 13) {
        url = 'Hey, you just pressed enter';
      }
    });    
  }
}