import Flutter
import UIKit
import com_awareframework_ios_sensor_barometer
import com_awareframework_ios_sensor_core
import awareframework_core

public class SwiftAwareframeworkBarometerPlugin: AwareFlutterPluginCore, FlutterPlugin, AwareFlutterPluginSensorInitializationHandler, BarometerObserver{


    public func initializeSensor(_ call: FlutterMethodCall, result: @escaping FlutterResult) -> AwareSensor? {
        if self.sensor == nil {
            if let config = call.arguments as? Dictionary<String,Any>{
                self.barometerSensor = BarometerSensor.init(BarometerSensor.Config(config))
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
        let instance = SwiftAwareframeworkBarometerPlugin();
        super.setMethodChannel(with: registrar, instance: instance, channelName: "awareframework_barometer/method")
        super.setEventChannels(with: registrar, instance: instance, channelNames:[ "awareframework_barometer/event","awareframework_barometer/event_on_data_changed"])

    }


    public func onDataChanged(data: BarometerData) {
        for handler in self.streamHandlers {
            if handler.eventName == "on_data_changed" {
                handler.eventSink(data.toDictionary())
            }
        }
    }
}
