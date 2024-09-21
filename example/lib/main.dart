import 'package:flutter/material.dart';
import 'package:awareframework_barometer/awareframework_barometer.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  BarometerSensor? sensor;
  BarometerSensorConfig? config;

  @override
  void initState() {
    super.initState();

    config = BarometerSensorConfig()..debug = true;
    config?.frequency = 1;
    config?.period = 0.1;

    sensor = new BarometerSensor.init(config!);
    sensor?.onDataChanged.listen((data) {
      print(data);
    });

    sensor?.start();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin Example App'),
        ),
      ),
    );
  }
}
