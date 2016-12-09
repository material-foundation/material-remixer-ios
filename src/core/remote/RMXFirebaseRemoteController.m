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

#import "RMXFirebaseRemoteController.h"

#ifdef REMIXER_CLOUD_FIREBASE

@import Firebase;

#import "RMXBooleanVariable.h"
#import "RMXRangeVariable.h"
#import "RMXRemixer.h"

static NSString *const kFirebasePath = @"Remixer";

@implementation RMXFirebaseRemoteController {
  NSString *_deviceKey;
  FIRDatabaseReference *_ref;
  NSMutableDictionary<NSString *, RMXVariable *> *_storedVariables;
}

+ (instancetype)sharedInstance {
  static id sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)startObservingUpdates {
  _deviceKey = [[[NSUUID UUID] UUIDString] substringToIndex:8];
  [FIRApp configure];
  _ref = [[FIRDatabase database] referenceWithPath:kFirebasePath];
  _storedVariables = [NSMutableDictionary dictionary];

  [[_ref child:_deviceKey]
       observeEventType:FIRDataEventTypeChildChanged
       withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
         NSDictionary *jsonDictionary = snapshot.value;
         RMXVariable *variable = [RMXRemixer variableForKey:snapshot.key];
         if (variable) {
           id value = [jsonDictionary objectForKey:RMXDictionaryKeySelectedValue];
           [RMXRemixer updateVariable:variable fromRemoteControllerToValue:value];
         }
   }];
}

- (void)stopObservingUpdates {
  [[_ref child:_deviceKey] removeAllObservers];
}

- (void)addVariable:(RMXVariable *)variable {
  [[[_ref child:_deviceKey] child:variable.key] setValue:[variable toJSON]];
}

- (void)updateVariable:(RMXVariable *)variable {
  [[[_ref child:_deviceKey] child:variable.key] setValue:[variable toJSON]];
}

- (void)removeVariable:(RMXVariable *)variable {
  [[[_ref child:_deviceKey] child:variable.key] removeValue];
}

- (void)removeAllVariables {
  [[_ref child:_deviceKey] removeValue];
}

@end

#endif
