//
//  NENativeExtensionsBridge.m
//  bluescape_mobile
//
//  Created by Leah Xia on 2019-11-04.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(NENativeExtensions, NSObject)

RCT_EXTERN_METHOD(
  calculateTextSize: (NSString *)text styles:(NSDictionary *)styles
  resolver: (RCTPromiseResolveBlock)resolve
  rejecter: (RCTPromiseRejectBlock)reject
)

@end
