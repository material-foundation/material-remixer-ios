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

#import "RMXVariable.h"
#import "RMXVariableConstants.h"

@interface VariableTests : XCTestCase
@end

@implementation VariableTests {
  RMXVariable *variable;
}

- (void)setUp {
  [super setUp];
  variable = [[RMXVariable alloc] initWithKey:@"a key"
                                     dataType:RMXDataTypeString
                                 defaultValue:@"default value"
                                  updateBlock:^(RMXVariable *variable, id selectedValue) {
                                    // no - op.
                                  }];
}

- (void)tearDown {
  variable = nil;
  [super tearDown];
}

- (void)testKeysAreSanitized {
  XCTAssertTrue([[variable key] isEqualToString:@"a_key"]);
}

- (void)testTitle {
  variable.title = @"";
  XCTAssertTrue([[variable title] isEqualToString:variable.key]);
  variable.title = @"a title";
  XCTAssertTrue([[variable title] isEqualToString:@"a title"]);
}

- (void)testConstraintType {
  variable.possibleValues = @[];
  XCTAssertTrue([[variable constraintType] isEqualToString:RMXConstraintTypeNone]);
  variable.possibleValues = @[@"onlyOption"];
  XCTAssertTrue([[variable constraintType] isEqualToString:RMXConstraintTypeList]);
}

- (void)testSettingSelectedValueCallsBlock {
  __block NSString *updateBlockTestString = @"block not executed";
  variable = [[RMXVariable alloc] initWithKey:@"a key"
                                     dataType:RMXDataTypeString
                                 defaultValue:@"default value"
                                  updateBlock:^(RMXVariable *variable, id selectedValue) {
                                    updateBlockTestString = selectedValue;
                                  }];
  XCTAssertTrue([updateBlockTestString isEqualToString:@"block not executed"]);
  variable.selectedValue = @"block executed";
  XCTAssertTrue([updateBlockTestString isEqualToString:variable.selectedValue]);
}

@end
