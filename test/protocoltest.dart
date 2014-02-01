import 'package:dartflightschool/protocol.dart';
import 'dart:async';

void main() {
  Protocol test = null;
  var input = test.open('/test2');
  var output = test.openWrite('/blubb');
  StreamConsumer tmp;
  input.pipe(output).then((val) {
    print("yeah.");
  });
}