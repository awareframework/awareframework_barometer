import Flutter
import UIKit
import SwiftyJSON
import com_awareframework_ios_sensor_barometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkBarometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, BarometerObserver{


    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                let json = JSON.init(config)
                self.barometerSensor = BarometerSensor.init(BarometerSensor.Config(json))
            }else{
                self.barometerSensor = BarometerSensor.init(BarometerSensor.Config())
            }
            self.barometerSensor?.CONFIG.sensorObserver = self
            return self.barometerSensor
        }else{
            return nil
        }
    }

    var barometerSensor:BarometerSensor?

    public override init() {
        super.init()
        super.initializationCallEventHandler = self
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        // add own channel
        super.setChannels(with: registrar,
                          instance: SwiftAwareframeworkBarometerPlugin(),
                          methodChannelName: "awareframework_barometer/method",
                          eventChannelName: "awareframework_barometer/event")

    }


    public func onDataChanged(data: BarometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
