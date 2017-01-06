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
#import <OCMock/OCMock.h>

#import "RMXRangeVariable.h"
#import "RMXRemixer.h"
#import "RMXVariableConstants.h"

@interface RangeVariableTests : XCTestCase
@end

@implementation RangeVariableTests {
  id _remixerClassMock;
  RMXRangeVariable *_rangeVariable;
}

- (void)setUp {
  [super setUp];
  _remixerClassMock = OCMClassMock([RMXRemixer class]);
  OCMStub([_remixerClassMock addVariable:[OCMArg any]]).andCall(self, @selector(returnArgument:));
  _rangeVariable =
      [RMXRangeVariable rangeVariableWithKey:@"key"
                                defaultValue:0
                                    minValue:0
                                    maxValue:1
                                   increment:0
                                 updateBlock:^(RMXNumberVariable *variable, CGFloat selectedValue) {
                                   // No-op.
                                 }];
}

- (void)tearDown {
  _rangeVariable = nil;
  [super tearDown];
}

- (void)testInitializerAddsVariable {
  OCMVerify([_remixerClassMock addVariable:[OCMArg isNotNil]]);
}

- (void)testSelectedValue {
  [_rangeVariable setSelectedValue:@(1)];
  XCTAssertEqual([_rangeVariable selectedFloatValue], 1);
}

- (void)testDataType {
  XCTAssertTrue([[_rangeVariable dataType] isEqualToString:RMXDataTypeNumber]);
}

- (void)testConstraintType {
  XCTAssertTrue([[_rangeVariable constraintType] isEqualToString:RMXConstraintTypeRange]);
}

- (void)testControlType {
  XCTAssertTrue([[_rangeVariable controlType] isEqualToString:RMXControlTypeSlider]);
  _rangeVariable =
      [RMXRangeVariable rangeVariableWithKey:@"another key"
                                defaultValue:0
                                    minValue:0
                                    maxValue:1
                                   increment:0.1
                                 updateBlock:^(RMXNumberVariable *variable, CGFloat selectedValue) {
                                   // No-op.
                                 }];
  XCTAssertTrue([[_rangeVariable controlType] isEqualToString:RMXControlTypeStepper]);
}

- (void)testSettingPossibleValuesThrowsException {
  NSArray *possibleValues = @[@0, @1];
  XCTAssertThrows([_rangeVariable setPossibleValues:possibleValues]);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end
