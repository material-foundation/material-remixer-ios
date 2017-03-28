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
#import "RMXRemixer+Private.h"
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
                                 updateBlock:nil];
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
                                 updateBlock:nil];
  XCTAssertTrue([[_colorVariable controlType] isEqualToString:RMXControlTypeColorList]);
}

- (void)testSerialization {
  _colorVariable.selectedValue = [UIColor colorWithRed:0.6 green:0.4 blue:0.2 alpha:0.5];
  NSDictionary *json = [_colorVariable toJSON];
  NSDictionary *colorJSON = json[RMXDictionaryKeySelectedValue];
  XCTAssertTrue([[colorJSON objectForKey:@"r"] integerValue] == 153);
  XCTAssertTrue([[colorJSON objectForKey:@"g"] integerValue] == 102);
  XCTAssertTrue([[colorJSON objectForKey:@"b"] integerValue] == 51);
  XCTAssertTrue([[colorJSON objectForKey:@"a"] integerValue] == 128);  // round up
}

- (void)testParsingFromDictionary {
  [(RMXVariable *)_colorVariable setSelectedValue:@{@"r": @(153), @"g": @(102), @"b": @(51), @"a": @(128)}];
  CGFloat r, g, b, a;
  [_colorVariable.selectedValue getRed:&r green:&g blue:&b alpha:&a];
  XCTAssertTrue(r == 153/255.0);
  XCTAssertTrue(g == 102/255.0);
  XCTAssertTrue(b == 51/255.0);
  XCTAssertTrue(a == 128/255.0);
}

#pragma mark - Private

- (id)returnArgument:(id)argument {
  return argument;
}

@end
