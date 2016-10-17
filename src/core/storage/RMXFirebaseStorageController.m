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
#import "RMXBooleanVariable.h"
#import "RMXRangeVariable.h"
#import "RMXRemixer.h"
#import "RMXVariableFactory.h"

// TODO(chuga): Figure out where to set this path.
static NSString *const kFirebasePath = @"iOSDemoApp";
static NSString *const kFirebaseKeyVariables = @"variables";

@implementation RMXFirebaseStorageController {
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

#pragma mark - <RMXStorageController>

- (void)setup {
  [FIRApp configure];

  [[FIRAuth auth] signInAnonymouslyWithCompletion:^(FIRUser *user, NSError *error){
  }];

  _ref = [[FIRDatabase database] referenceWithPath:kFirebasePath];
  _storedVariables = [NSMutableDictionary dictionary];
  [[_ref child:kFirebaseKeyVariables]
      observeSingleEventOfType:FIRDataEventTypeValue
                     withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
                       NSDictionary *variables = snapshot.value;
                       if ([variables isEqual:[NSNull null]]) {
                         return;
                       }
                       for (NSDictionary *json in [variables allValues]) {
                         RMXVariable *cloudVariable =
                             [RMXVariableFactory variableFromJSONDictionary:json];
                         if (cloudVariable) {
                           [_storedVariables setObject:cloudVariable
                                                forKey:json[RMXDictionaryKeyKey]];
                           RMXVariable *variable = [RMXRemixer variableForKey:snapshot.key];
                           if (variable) {
                             [RMXRemixer updateVariable:variable
                                    usingStoredVariable:cloudVariable];
                           }
                         }
                       }
                     }];
}

- (void)startObservingUpdates {
  [[_ref child:kFirebaseKeyVariables]
      observeEventType:FIRDataEventTypeChildChanged
             withBlock:^(FIRDataSnapshot *_Nonnull snapshot) {
               RMXVariable *updatedVariable =
                   [RMXVariableFactory variableFromJSONDictionary:snapshot.value];
               [_storedVariables setObject:updatedVariable forKey:snapshot.key];
               RMXVariable *variable = [RMXRemixer variableForKey:snapshot.key];
               if (variable) {
                 [RMXRemixer updateVariable:variable usingStoredVariable:updatedVariable];
               }
             }];
}

- (void)stopObservingUpdates {
  [[_ref child:kFirebaseKeyVariables] removeAllObservers];
}

- (void)shutDown {
  // No-op.
}

- (RMXVariable *)variableForKey:(NSString *)key {
  return [_storedVariables objectForKey:key];
}

- (void)saveVariable:(RMXVariable *)variable {
  [[[_ref child:kFirebaseKeyVariables] child:variable.key] setValue:[variable toJSON]];
}

@end
