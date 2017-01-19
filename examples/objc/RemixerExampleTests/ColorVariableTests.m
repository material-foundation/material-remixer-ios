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

#import "RMXColorVariable.h"
#import "RMXRemixer.h"
#import "RMXVariableConstants.h"

@interface ColorVariableTests : XCTestCase
@end

@implementation ColorVariableTests {
  id _remixerClassMock;
  RMXColorVariable *_colorVariable;
}

- (void)setUp {
  [super setUp];
  _remixerClassMock = OCMClassMock([RMXRemixer class]);
  OCMStub([_remixerClassMock addVariable:[OCMArg any]]).andCall(self, @selector(returnArgument:));
  _colorVariable =
      [RMXColorVariable colorVariableWithKey:@"key"
                                defaultValue:[UIColor redColor]
                             limitedToValues:nil
                                 updateBlock:^(RMXColorVariable *variable, UIColor *selectedValue) {
                                   //
                                 }];
}

- (void)tearDown {
  _colorVariable = nil;
  [super tearDown];
}

- (void)testInitializerAddsVariable {
  OCMVerify([_remixerClassMock addVariable:[OCMArg isNotNil]]);
}

- (void)testSelectedValue {
  [_colorVariable setSelectedValue:[UIColor purpleColor]];
  XCTAssertEqual([_colorVariable selectedValue], [UIColor purpleColor]);
}

- (void)testDataType {
  XCTAssertTrue([[_colorVariable dataType] isEqualToString:RMXDataTypeColor]);
}

- (void)testControlType {
  XCTAssertTrue([[_colorVariable controlType] isEqualToString:RMXControlTypeColorInput]);
  _colorVariable =
      [RMXColorVariable colorVariableWithKey:@"another key"
                                defaultValue:[UIColor redColor]
                             limitedToValues:@[[UIColor redColor], [UIColor yellowColor]]
                                 updateBlock:^(RMXColorVariable *variable, UIColor *selectedValue) {
                                   //
                                 }];
  XCTAssertTrue([[_colorVariable controlType] isEqualToString:RMXControlTypeColorList]);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end
