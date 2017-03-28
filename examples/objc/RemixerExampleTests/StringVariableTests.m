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

#import "RMXStringVariable.h"
#import "RMXRemixer+Private.h"
#import "RMXVariableConstants.h"

@interface StringVariableTests : XCTestCase
@end

@implementation StringVariableTests {
  id _remixerClassMock;
  RMXStringVariable *_stringVariable;
}

- (void)setUp {
  [super setUp];
  _remixerClassMock = OCMClassMock([RMXRemixer class]);
  OCMStub([_remixerClassMock addVariable:[OCMArg any]]).andCall(self, @selector(returnArgument:));
  _stringVariable =
      [RMXStringVariable stringVariableWithKey:@"key"
                                  defaultValue:@"default value"
                               limitedToValues:nil
                                   updateBlock:nil];
}

- (void)tearDown {
  _stringVariable = nil;
  [super tearDown];
}

- (void)testInitializerAddsVariable {
  OCMVerify([_remixerClassMock addVariable:[OCMArg isNotNil]]);
}

- (void)testDataType {
  XCTAssertTrue([[_stringVariable dataType] isEqualToString:RMXDataTypeString]);
}

- (void)testControlType {
  XCTAssertTrue([[_stringVariable controlType] isEqualToString:RMXControlTypeTextInput]);
  _stringVariable =
      [RMXStringVariable stringVariableWithKey:@"another key"
                                  defaultValue:@"default value"
                               limitedToValues:@[@"option 1", @"option 2"]
                                   updateBlock:nil];
  XCTAssertTrue([[_stringVariable controlType] isEqualToString:RMXControlTypeTextList]);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end

