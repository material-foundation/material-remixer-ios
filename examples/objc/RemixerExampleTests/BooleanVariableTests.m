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

#import "RMXBooleanVariable.h"
#import "RMXRemixer+Private.h"
#import "RMXVariableConstants.h"

@interface BooleanVariableTests : XCTestCase
@end

@implementation BooleanVariableTests {
  id remixerClassMock;
  RMXBooleanVariable *booleanVariable;
}

- (void)setUp {
  [super setUp];
  remixerClassMock = OCMClassMock([RMXRemixer class]);
  OCMStub([remixerClassMock addVariable:[OCMArg any]]).andCall(self, @selector(returnArgument:));
  booleanVariable =
      [RMXBooleanVariable booleanVariableWithKey:@"a key"
                                    defaultValue:YES
                                     updateBlock:nil];
}

- (void)tearDown {
  booleanVariable = nil;
  [super tearDown];
}

- (void)testInitializerAddsVariable {
  OCMVerify([remixerClassMock addVariable:[OCMArg isNotNil]]);
}

- (void)testSelectedValue {
  [booleanVariable setSelectedBooleanValue:NO];
  XCTAssertEqual([booleanVariable selectedBooleanValue], NO);
  [booleanVariable setSelectedBooleanValue:YES];
  XCTAssertEqual([booleanVariable selectedBooleanValue], YES);
}

- (void)testDataType {
  XCTAssertTrue([[booleanVariable dataType] isEqualToString:RMXDataTypeBoolean]);
}

- (void)testControlType {
  XCTAssertTrue([[booleanVariable controlType] isEqualToString:RMXControlTypeSwitch]);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end
