#import "UserGuidcancePlugin.h"
#if __has_include(<user_guidcance/user_guidcance-Swift.h>)
#import <user_guidcance/user_guidcance-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "user_guidcance-Swift.h"
#endif

@implementation UserGuidcancePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftUserGuidcancePlugin registerWithRegistrar:registrar];
}
@end
