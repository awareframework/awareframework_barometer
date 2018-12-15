import 'package:test/test.dart';

import 'package:awareframework_barometer/awareframework_barometer.dart';

void main(){
  test("test sensor config", (){
    var config = BarometerSensorConfig();
    expect(config.debug, false);
  });
}