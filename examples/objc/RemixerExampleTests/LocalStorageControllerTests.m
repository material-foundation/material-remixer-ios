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

#import <XCTest/XCTest.h>

#import "RMXLocalStorageController.h"
#import "RMXBooleanVariable.h"
#import "RMXColorVariable.h"

@interface LocalStorageControllerTests : XCTestCase
@end

@implementation LocalStorageControllerTests

- (void)testThatItWorksWithBasicDataTypes {
  RMXLocalStorageController *localStorage = [[RMXLocalStorageController alloc] init];
  RMXBooleanVariable *booleanVariable =
      [RMXBooleanVariable booleanVariableWithKey:@"rmxtest_booleanVariableKey"
          defaultValue:YES
           updateBlock:^(RMXBooleanVariable *variable, BOOL selectedValue) {
             // No - op.
           }];

  [localStorage saveSelectedValueOfVariable:booleanVariable];
  XCTAssertEqual([localStorage selectedValueForVariableKey:booleanVariable.key],
                 booleanVariable.selectedValue);

  [booleanVariable setSelectedBooleanValue:NO];
  [localStorage saveSelectedValueOfVariable:booleanVariable];
  XCTAssertEqual([localStorage selectedValueForVariableKey:booleanVariable.key],
                 booleanVariable.selectedValue);

  [[NSUserDefaults standardUserDefaults] removeObjectForKey:booleanVariable.key];
}

- (void)testThatItWorksWithAdvancedDataTypes {
  RMXLocalStorageController *localStorage = [[RMXLocalStorageController alloc] init];
  RMXColorVariable *colorVariable =
      [RMXColorVariable colorVariableWithKey:@"rmxtest_colorVariableKey"
                                defaultValue:[UIColor redColor]
                              possibleValues:nil
                                 updateBlock:^(RMXColorVariable *variable, UIColor *selectedValue) {
                                   // No - op.
                                 }];

  [localStorage saveSelectedValueOfVariable:colorVariable];

  UIColor *originalColor = [colorVariable selectedValue];
  [colorVariable setSelectedValue:[localStorage selectedValueForVariableKey:colorVariable.key]];
  XCTAssertTrue([originalColor isEqual:[colorVariable selectedValue]]);

  [[NSUserDefaults standardUserDefaults] removeObjectForKey:colorVariable.key];
}

@end
