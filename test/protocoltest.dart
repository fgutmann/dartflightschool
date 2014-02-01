import 'package:dartflightschool/protocol.dart';
import 'dart:async';

void main() {
  Protocol test = null;
  Stream<List<int>> input = test.open('/test2');
  var output = test.openWrite('/blubb');
  input.pipe(test.openWrite('/blubb'));
  input.pipe(output).then((val) {
    print("yeah.");
  });
}