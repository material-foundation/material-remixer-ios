/*
 Copyright 2016-present Google Inc. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#if !defined(__has_feature) || !__has_feature(objc_arc)
#error "This file requires ARC support."
#endif

#import "RMXOverlayResources.h"

// The Bundle for icon resources.
static NSString *const kBundleName = @"Remixer.bundle";

// Icons.
NSString *const RMXIconCheck = @"ic_check";
NSString *const RMXIconClose = @"ic_close";
NSString *const RMXIconArrowDown = @"ic_arrow_down";
NSString *const RMXIconDropDown = @"ic_arrow_drop_down";
NSString *const RMXIconLaunch = @"ic_launch";
NSString *const RMXIconRestore = @"ic_restore";
NSString *const RMXIconShare = @"ic_share";
NSString *const RMXIconWifi = @"ic_wifi_tethering";

@implementation RMXOverlayResources

+ (UIImage *)iconWithName:(NSString *)name {
  NSString *imagePath = [[self bundle] pathForResource:name ofType:@"png"];
  return [[UIImage imageWithContentsOfFile:imagePath]
      imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (NSBundle *)bundle {
  static NSBundle *bundle = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    bundle = [NSBundle bundleWithPath:[self bundlePathWithName:kBundleName]];
  });
  return bundle;
}

+ (NSString *)bundlePathWithName:(NSString *)bundleName {
  NSBundle *bundle = [NSBundle bundleForClass:[self class]];
  NSString *resourcePath = [(nil == bundle ? [NSBundle mainBundle] : bundle)resourcePath];
  return [resourcePath stringByAppendingPathComponent:bundleName];
}

@end
