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

#import "RMXFirebaseStorageController.h"

#import "Firebase.h"
#import "RMXBooleanRemix.h"
#import "RMXRangeRemix.h"
#import "RMXRemixer.h"
#import "RMXRemixFactory.h"

//TODO(chuga): Figure out where to set this path.
static NSString *const kFirebasePath = @"iOSDemoApp";
static NSString *const kFirebaseKeyRemixes = @"remixes";

@implementation RMXFirebaseStorageController  {
  FIRDatabaseReference *_ref;
  NSMutableDictionary<NSString *, RMXRemix *> *_storedRemixes;
}

+ (instancetype)sharedInstance {
  static id sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

#pragma mark - <RMXStorageController>

- (void)setup {
  [FIRApp configure];
  
  [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *user, NSError *error) {
  }];
  
  _ref = [[FIRDatabase database] referenceWithPath:kFirebasePath];
  _storedRemixes = [NSMutableDictionary dictionary];
  [[_ref child:kFirebaseKeyRemixes]
       observeSingleEventOfType:FIRDataEventTypeValue
                      withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
                        NSDictionary *remixes = snapshot.value;
                        if ([remixes isEqual:[NSNull null]]) {
                          return;
                        }
                        for (NSDictionary *json in [remixes allValues]) {
                         [_storedRemixes setObject:[RMXRemixFactory remixFromJSONDictionary:json]
                                            forKey:json[RMXDictionaryKeyKey]];
                        }
                      }];
}

- (void)startObservingUpdates {
  [[_ref child:kFirebaseKeyRemixes]
       observeEventType:FIRDataEventTypeChildChanged
              withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
                RMXRemix *updatedRemix = [RMXRemixFactory remixFromJSONDictionary:snapshot.value];
                [_storedRemixes setObject:updatedRemix
                                   forKey:snapshot.key];
                RMXRemix *remix = [RMXRemixer remixForKey:snapshot.key];
                if (remix) {
                  [RMXRemixer updateRemix:remix usingStoredRemix:updatedRemix];
                }
              }];
}

- (void)stopObservingUpdates {
  [[_ref child:kFirebaseKeyRemixes] removeAllObservers];
}

- (void)shutDown {
  // No-op.
}

- (RMXRemix *)remixForKey:(NSString *)key {
  return [_storedRemixes objectForKey:key];
}

- (void)saveRemix:(RMXRemix *)remix {
  [[[_ref child:kFirebaseKeyRemixes] child:remix.key] setValue:[remix toJSON]];
}

@end
