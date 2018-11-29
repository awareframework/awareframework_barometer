import 'dart:async';

import 'package:flutter/services.dart';
import 'package:awareframework_core/awareframework_core.dart';
import 'package:flutter/material.dart';

/// init sensor
class BarometerSensor extends AwareSensorCore {
  static const MethodChannel _barometerMethod = const MethodChannel('awareframework_barometer/method');
  static const EventChannel  _barometerStream  = const EventChannel('awareframework_barometer/event');

  /// Init Barometer Sensor with BarometerSensorConfig
  BarometerSensor(BarometerSensorConfig config):this.convenience(config);
  BarometerSensor.convenience(config) : super(config){
    super.setMethodChannel(_barometerMethod);
  }

  /// A sensor observer instance
  Stream<Map<String,dynamic>> get onDataChanged {
     return super.getBroadcastStream(
         _barometerStream, "on_data_changed"
     ).map( (dynamic event) => Map<String,dynamic>.from(event) );
  }

  @override
  void cancelAllEventChannels() {
    super.cancelBroadcastStream("on_data_changed");
  }
}

class BarometerSensorConfig extends AwareSensorConfig{
  BarometerSensorConfig();

  int frequency = 5;
  double period = 1;
  double threshold = 0.0;

  @override
  Map<String, dynamic> toMap() {
    var map = super.toMap();
    map['frequency'] = frequency;
    map['period']    = period;
    map['threshold'] = threshold;
    return map;
  }
}

/// Make an AwareWidget
class BarometerCard extends StatefulWidget {
  BarometerCard({Key key, @required this.sensor,
                                    this.height = 250.0,
                                    this.bufferSize = 299}) : super(key: key);

  final BarometerSensor sensor;
  final double height;
  final int bufferSize;

  final List<LineSeriesData> dataLine1 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine2 = List<LineSeriesData>();
  final List<LineSeriesData> dataLine3 = List<LineSeriesData>();

  @override
  BarometerCardState createState() => new BarometerCardState();
}


class BarometerCardState extends State<BarometerCard> {

  @override
  void initState() {

    super.initState();
    // set observer
    widget.sensor.onDataChanged.listen((event) {
      setState((){
        if(event!=null){
          DateTime.fromMicrosecondsSinceEpoch(event['timestamp']);
          StreamLineSeriesChart.add(
              data:   event['pressure'],
              into:   widget.dataLine1,
              id:     "barometer",
              buffer: widget.bufferSize
          );
        }
      });
    }, onError: (dynamic error) {
        print('Received error: ${error.message}');
    });
    print(widget.sensor);
  }

  @override
  Widget build(BuildContext context) {
    var data = StreamLineSeriesChart.createTimeSeriesData(
        widget.dataLine1,
        widget.dataLine2,
        widget.dataLine3
    );
    return new AwareCard(
      contentWidget: SizedBox(
          height:widget.height,
          width: MediaQuery.of(context).size.width*0.8,
          child: new StreamLineSeriesChart(data),
        ),
      title: "Barometer",
      sensor: widget.sensor
    );
  }

  @override
  void dispose() {
    widget.sensor.cancelAllEventChannels();
    super.dispose();
  }

}
