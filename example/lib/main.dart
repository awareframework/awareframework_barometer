import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_barometer/awareframework_barometer.dart';
import 'package:awareframework_core/awareframework_core.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  BarometerSensor sensor;
  BarometerSensorConfig config;

  @override
  void initState() {
    super.initState();

    config = BarometerSensorConfig()
      ..debug = true;

    sensor = new BarometerSensor.init(config);

    sensor.start();

  }

  @override
  Widget build(BuildContext context) {


    return new MaterialApp(
      home: new Scaffold(
          appBar: new AppBar(
            title: const Text('Plugin Example App'),
          ),
          body: new BarometerCard(sensor: sensor, height: 100.0,)
      ),
    );
  }
}
