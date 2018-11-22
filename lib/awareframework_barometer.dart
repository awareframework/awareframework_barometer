import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

/// init sensor
class BarometerSensor extends AwareSensorCore {
  static const MethodChannel _barometerMethod = const MethodChannel('awareframework_barometer/method');
  static const EventChannel  _barometerStream  = const EventChannel('awareframework_barometer/event');

  /// Init Barometer Sensor with BarometerSensorConfig
  BarometerSensor(BarometerSensorConfig config):this.convenience(config);
  BarometerSensor.convenience(config) : super(config){
    /// Set sensor method & event channels
    super.setSensorChannels(_barometerMethod, _barometerStream);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.receiveBroadcastStream("on_data_changed").map((dynamic event) => Map<String,dynamic>.from(event));
  }
}

class BarometerSensorConfig extends AwareSensorConfig{
  BarometerSensorConfig();

  /// TODO

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    return map;
  }
}

/// Make an AwareWidget
class BarometerCard extends StatefulWidget {
  BarometerCard({Key key, @required this.sensor}) : super(key: key);

  BarometerSensor sensor;

  @override
  BarometerCardState createState() => new BarometerCardState();
}


class BarometerCardState extends State<BarometerCard> {

  List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  List<LineSeriesData> dataLine3 = List<LineSeriesData>();
  int bufferSize = 299;

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(data:event['pressure'], into:dataLine1, id:"barometer", buffer: bufferSize);
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }


  @override
  Widget build(BuildContext context) {
    return new AwareCard(
      contentWidget: SizedBox(
          height:250.0,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(StreamLineSeriesChart.createTimeSeriesData(dataLine1, dataLine2, dataLine3) ),
        ),
      title: "Barometer",
      sensor: widget.sensor
    );
  }

}
