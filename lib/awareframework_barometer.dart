import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';

/// This is an Aware Framework plugin for monitoring motion activities.
/// This package allows us to monitor motion activity data such as running,
/// walking, and automotive.
///
/// Your can initialize this class by the following code.
/// ```dart
/// var sensor  BarometerSensor();
/// ```
///
/// If you need to initialize the sensor with configurations,
/// you can use the following code instead of the above code.
///
/// ```dart
/// var config = BarometerSensorConfig();
/// config
///   ..debug = true
///
/// var sensor  BarometerSensor.init(config);
/// ```
///
/// Each sub class of AwareSensor provides the following method for controlling
/// the sensor:
/// - `start()`
/// - `stop()`
/// - `enable()`
/// - `disable()`
/// - `sync()`
/// - `setLabel(String label)`
///
/// `Strea BarometerData>` allow us to monitor the sensor update
/// events as follows:
///
/// ```dart
/// sensor.onDataChanged.listen((data) {
///   print(data)
/// }
/// ```
///
/// In addition, this package support data visualization function on Cart Widget.
/// You can generate the Cart Widget by following code.
///
/// ```dart
/// var card  BarometerCard(sensor: sensor);
/// ```
///
class BarometerSensor extends AwareSensor {
  static const MethodChannel _barometerMethod =
      const MethodChannel('awareframework_barometer/method');
//  static const EventChannel  _barometerStream  = const EventChannel('awareframework_barometer/event');
  static const EventChannel _onDataChangedStream =
      const EventChannel('awareframework_barometer/event_on_data_changed');

  BarometerData data = BarometerData();
  static StreamController<BarometerData> streamController =
      StreamController<BarometerData>();

  /// Init  Barometer Sensor without a configuration file
  ///
  /// ```dart
  /// var sensor = BarometerSensor();
  /// ```
  BarometerSensor() : super(null);

  /// Init  Barometer Sensor with  BarometerSensorConfig
  ///
  /// ```dart
  /// var config =   BarometerSensorConfig();
  /// config
  ///   ..debug = true
  ///   ..frequency = 100;
  ///
  /// var sensor =  BarometerSensor.init(config);
  /// ```
  BarometerSensor.init(BarometerSensorConfig config) : super(config) {
    super.setMethodChannel(_barometerMethod);
  }

  /// An event channel for monitoring sensor events.
  ///
  /// `Stream<Map<String,dynamic>>` allow us to monitor the sensor update
  /// events as follows:
  ///
  /// ```dart
  /// sensor.onDataChanged.listen((data) {
  ///   print(data)
  /// }
  ///
  Stream<BarometerData> get onDataChanged {
    streamController.close();
    streamController = StreamController<BarometerData>();
    return streamController.stream;
  }

  @override
  Future<Null> start() {
    // set a stream channel
    super
        .getBroadcastStream(_onDataChangedStream, "on_data_changed")
        .map((dynamic event) =>
            BarometerData.from(Map<String, dynamic>.from(event)))
        .listen((event) {
      if (!streamController.isClosed) {
        streamController.add(event);
      }
    });
    // start sensor
    return super.start();
  }

  @override
  Future<Null> stop() {
    // cancel a stream channel
    super.cancelBroadcastStream("on_data_changed");
    // stop sensor
    return super.stop();
  }
}

/// A configuration class of BarometerSensor
///
/// You can initialize the class by following code.
///
/// ```dart
/// var config =  BarometerSensorConfig();
/// config
///   ..debug = true
/// ``
class BarometerSensorConfig extends AwareSensorConfig {
  BarometerSensorConfig();

  int frequency = 5;
  double period = 1;
  double threshold = 0.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period'] = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// A data model of AccelerometerSensor
///
/// This class converts sensor data that is Map<String,dynamic> format, to a
/// sensor data object.
///
class BarometerData extends AwareData {
  double pressure = 0.0;
  int eventTimestamp = 0;
  BarometerData() : this.from({});
  BarometerData.from(Map<String, dynamic>? data) : super(data ?? {}) {
    if (data != null) {
      pressure = data["pressure"] ?? 0.0;
      eventTimestamp = data["eventTimestamp"] ?? 0;
    }
  }
}
