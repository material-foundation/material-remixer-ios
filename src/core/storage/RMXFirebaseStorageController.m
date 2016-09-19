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
#import "RMXRemix.h"
#import "RMXRemixer.h"

static NSString *const kKeyRemixes = @"remixes";
static NSString *const kKeySelectedValue = @"selectedValue";
static NSString *const kKeySessionId = @"sessionId";

@implementation RMXFirebaseStorageController  {
  FIRDatabaseReference *_ref;
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
  
  _ref = [[FIRDatabase database] referenceWithPath:[self sessionId]];
}

- (void)startObservingEvents {
  [[_ref child:kKeyRemixes] observeEventType:FIRDataEventTypeChildChanged
                                   withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
                                     RMXRemix *remix = [RMXRemixer remixForKey:snapshot.key];
                                     if (remix) {
                                       id value = snapshot.value[kKeySelectedValue];
                                       [remix setSelectedValue:value fromOverlay:NO];
                                     }
                                   }];
}

- (void)stopObservingEvents {
  [[_ref child:kKeyRemixes] removeAllObservers];
}

- (void)shutDown {
}

- (id)remixForKey:(NSString *)key {
  return [[_ref child:kKeyRemixes] child:key];
}

- (void)saveRemix:(RMXRemix *)remix {
  [[[_ref child:kKeyRemixes] child:remix.key] setValue:[remix toJSON]];
}

#pragma mark - Private

- (NSString *)sessionId {
  NSString *_sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:kKeySessionId];
  if (!_sessionId) {
    _sessionId = [[[NSUUID UUID] UUIDString] substringToIndex:8];
    [[NSUserDefaults standardUserDefaults] setObject:_sessionId forKey:kKeySessionId];
  }
  return _sessionId;
}

@end
