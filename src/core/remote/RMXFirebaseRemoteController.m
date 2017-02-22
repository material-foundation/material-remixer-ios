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

@import Firebase;

#import "RMXBooleanVariable.h"
#import "RMXRangeVariable.h"
#import "RMXRemixer.h"

static NSString *const kFirebasePath = @"remixer";
static NSString *const kSharingUserDefaultKey = @"remixerSharingBool";
static NSString *const kFirebaseDatabaseDomain = @"firebaseio";
static NSString *const kFirebaseAppDomain = @"firebaseapp";

@implementation RMXFirebaseRemoteController {
  NSString *_identifier;
  FIRDatabaseReference *_ref;
  NSMutableDictionary<NSString *, RMXVariable *> *_storedVariables;
}

@synthesize sharing = _sharing;

- (instancetype)init {
  self = [super init];
  if (self) {
    _identifier = [RMXRemixer sessionId];
    _storedVariables = [NSMutableDictionary dictionary];
    [FIRApp configure];
    self.sharing =
        [[[NSUserDefaults standardUserDefaults] objectForKey:kSharingUserDefaultKey] boolValue];
  }
  return self;
}

- (void)setSharing:(BOOL)sharing {
  _sharing = sharing;
  if (_sharing) {
    [self restartConnection];
  } else {
    [self pauseConnection];
  }
  [[NSUserDefaults standardUserDefaults] setObject:@(_sharing) forKey:kSharingUserDefaultKey];
}

- (void)restartConnection{
  if (!_sharing) {
    return;
  }
  _ref = [[FIRDatabase database] referenceWithPath:kFirebasePath];
  [[_ref child:_identifier] onDisconnectRemoveValue];
  [self removeAllVariables];
  [self saveAllVariables];
  [self startObservingUpdates];
}

- (void)pauseConnection {
  [self removeAllVariables];
  [self stopObservingUpdates];
  _ref = nil;
}

- (void)saveAllVariables {
  for (RMXVariable *variable in [RMXRemixer allVariables]) {
    [self addVariable:variable];
  }
}

- (void)addVariable:(RMXVariable *)variable {
  [[[_ref child:_identifier] child:variable.key] setValue:[variable toJSON]];
}

- (void)updateVariable:(RMXVariable *)variable {
  [[[_ref child:_identifier] child:variable.key] setValue:[variable toJSON]];
}

- (void)removeVariable:(RMXVariable *)variable {
  [[[_ref child:_identifier] child:variable.key] removeValue];
}

- (void)removeAllVariables {
  [[_ref child:_identifier] removeValue];
}

- (NSURL *)remoteControllerURL {
  FIROptions *options = [[FIRApp defaultApp] options];
  NSString *baseURL =
      [options.databaseURL stringByReplacingOccurrencesOfString:kFirebaseDatabaseDomain
                                                     withString:kFirebaseAppDomain];
  NSString *fullURL =
      [NSString stringWithFormat:@"%@%@%@", baseURL, @"/", [RMXRemixer sessionId]];
  return [NSURL URLWithString:fullURL];
}

#pragma mark - Private

- (void)startObservingUpdates {
  [[_ref child:_identifier]
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
  [[_ref child:_identifier] removeAllObservers];
}

@end
