#import "AwareframeworkBarometerPlugin.h"
#import <awareframework_barometer/awareframework_barometer-Swift.h>

@implementation AwareframeworkBarometerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAwareframeworkBarometerPlugin registerWithRegistrar:registrar];
}
@end
