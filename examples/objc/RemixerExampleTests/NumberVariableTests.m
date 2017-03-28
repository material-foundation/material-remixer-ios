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

#import "RMXNumberVariable.h"
#import "RMXRemixer+Private.h"
#import "RMXVariableConstants.h"

@interface NumberVariableTests : XCTestCase
@end

@implementation NumberVariableTests {
  id _remixerClassMock;
  RMXNumberVariable *_numberVariable;
}

- (void)setUp {
  [super setUp];
  _remixerClassMock = OCMClassMock([RMXRemixer class]);
  OCMStub([_remixerClassMock addVariable:[OCMArg any]]).andCall(self, @selector(returnArgument:));
  _numberVariable =
      [RMXNumberVariable numberVariableWithKey:@"key"
                                  defaultValue:1
                               limitedToValues:nil
                                   updateBlock:nil];
}

- (void)tearDown {
  _numberVariable = nil;
  [super tearDown];
}

- (void)testInitializerAddsVariable {
  OCMVerify([_remixerClassMock addVariable:[OCMArg isNotNil]]);
}

- (void)testSelectedValue {
  [_numberVariable setSelectedValue:@(2)];
  XCTAssertEqual([_numberVariable selectedFloatValue], 2);
}

- (void)testDataType {
  XCTAssertTrue([[_numberVariable dataType] isEqualToString:RMXDataTypeNumber]);
}

- (void)testControlType {
  XCTAssertTrue([[_numberVariable controlType] isEqualToString:RMXControlTypeTextInput]);
  _numberVariable =
      [RMXNumberVariable numberVariableWithKey:@"another key"
                                  defaultValue:1
                               limitedToValues:@[@(1), @(2)]
                                   updateBlock:nil];
  XCTAssertTrue([[_numberVariable controlType] isEqualToString:RMXControlTypeTextList]);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end
