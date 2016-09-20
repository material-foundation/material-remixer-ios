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

#import "RMXFirebaseHost.h"

#import "Firebase.h"
#import "RMXRemixer.h"

static NSString *const kKeyRemixes = @"remixes";
static NSString *const kKeySelectedValue = @"selectedValue";

@implementation RMXFirebaseHost {
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

- (void)start {
  [FIRApp configure];

  // TODO(cjcox): Set up proper authentication.
  [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *user, NSError *error){

  }];

  _ref = [[FIRDatabase database] referenceWithPath:[RMXRemixer sessionId]];

  // Update remixes with changes from firebase.
  [[_ref child:kKeyRemixes] observeEventType:FIRDataEventTypeChildChanged
                                   withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
                                     RMXRemix *remix = [RMXRemixer remixForKey:snapshot.key];
                                     if (remix) {
                                       id value = snapshot.value[kKeySelectedValue];
                                       [remix setSelectedValue:value fromOverlay:NO];
                                     }
                                   }];

  // Remove remixes when disconnected.
  [[_ref child:kKeyRemixes] onDisconnectRemoveValue];
}

- (void)stop {
}

- (void)saveRemix:(RMXRemix *)remix {
  [[[_ref child:kKeyRemixes] child:remix.key] setValue:[remix toJSON]];
}

- (void)removeRemixWithKey:(NSString *)key {
  [[[_ref child:kKeyRemixes] child:key] removeValue];
}

- (void)removeAllRemixes {
  [[_ref child:kKeyRemixes] removeValue];
}

@end
