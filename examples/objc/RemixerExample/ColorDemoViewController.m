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

#import "ColorDemoViewController.h"

#import "Remixer.h"

@implementation ColorDemoViewController {
  UIView *_box;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  _box = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
  _box.backgroundColor = [UIColor redColor];
  [self.view addSubview:_box];

  // Add color picker.
  [RMXColorVariable
      colorVariableWithKey:@"boxBgColor"
              defaultValue:[UIColor redColor]
            possibleValues:@[ [UIColor redColor], [UIColor blueColor], [UIColor greenColor] ]
               updateBlock:^(RMXColorVariable *_Nonnull variable, UIColor *selectedValue) {
                 _box.backgroundColor = selectedValue;
               }];

  // Add segment control.
  NSArray *themesOptions = @[ @"Light", @"Dark" ];
  RMXStringVariable *themeVariable = [RMXStringVariable
      stringVariableWithKey:@"theme"
               defaultValue:themesOptions[0]
             possibleValues:themesOptions
                updateBlock:^(RMXStringVariable *_Nonnull variable, NSString *selectedValue) {
                  self.view.backgroundColor = ([selectedValue isEqualToString:@"Light"])
                                                  ? [UIColor whiteColor]
                                                  : [UIColor darkGrayColor];
                }];
  themeVariable.controlType = RMXControlTypeSegmented;

  // Add slider control.
  [RMXRangeVariable
      rangeVariableWithKey:@"alpha"
              defaultValue:1
                  minValue:0
                  maxValue:1
                 increment:0
               updateBlock:^(RMXNumberVariable *_Nonnull variable, CGFloat selectedValue) {
                 _box.alpha = selectedValue;
               }];

  // Add stepper control.
  [RMXRangeVariable
      rangeVariableWithKey:@"width"
              defaultValue:80
                  minValue:40
                  maxValue:200
                 increment:20
               updateBlock:^(RMXNumberVariable *_Nonnull variable, CGFloat selectedValue) {
                 CGRect frame = _box.frame;
                 frame.size.width = selectedValue;
                 _box.frame = frame;
               }];

  // Add switch control.
  [RMXBooleanVariable
      booleanVariableWithKey:@"show"
                defaultValue:YES
                 updateBlock:^(RMXBooleanVariable *_Nonnull variable, BOOL selectedValue) {
                   _box.hidden = !selectedValue;
                 }];

  // TODO(chuga): Add a Trigger Remix for printing the session ID.
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [RMXRemixer removeAllVariables];
}

@end
