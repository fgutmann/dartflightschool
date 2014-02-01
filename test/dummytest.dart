import 'package:unittest/unittest.dart';

import 'package:dartflightschool/dummyimpl.dart';
import 'package:dartflightschool/protocol.dart' as p;

void main() {
  test('list', () {
    var dummyFs = new DummyFs();
    dummyFs.list("/").then((List<p.File> tmp){
      print("We got a file list.. ${tmp}");
    });
  });
}