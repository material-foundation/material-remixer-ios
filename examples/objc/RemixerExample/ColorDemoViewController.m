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
  NSArray *colorOptions = @[ [UIColor blueColor], [UIColor redColor], [UIColor greenColor] ];
  RMXColorPicker *colorPickerControl =
      [RMXColorPicker controlWithTitle:@"Color Picker" itemList:colorOptions];
  [RMXRemix addRemixWithKey:@"colorPicker"
               usingControl:colorPickerControl
              selectedValue:@(1)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  _box.backgroundColor = colorOptions[[selectedValue integerValue]];
                }];

  // Add segment control.
  RMXSegmented *segmentControl =
      [RMXSegmented controlWithTitle:@"Theme" itemList:@[ @"Light", @"Dark" ]];
  [RMXRemix addRemixWithKey:@"theme"
               usingControl:segmentControl
              selectedValue:@(0)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  self.view.backgroundColor = ([selectedValue integerValue] == 0)
                                                  ? [UIColor whiteColor]
                                                  : [UIColor darkGrayColor];
                }];

  // Add slider control.
  RMXSlider *sliderControl = [RMXSlider controlWithTitle:@"Alpha" minimumValue:0 maximumValue:1];
  [RMXRemix addRemixWithKey:@"alpha"
               usingControl:sliderControl
              selectedValue:@(1)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  _box.alpha = [selectedValue floatValue];
                }];

  // Add stepper control.
  RMXStepper *stepper =
      [RMXStepper controlWithTitle:@"Box Width" minimumValue:40 maximumValue:200 stepValue:20];
  [RMXRemix addRemixWithKey:@"width"
               usingControl:stepper
              selectedValue:@(80)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  CGRect frame = _box.frame;
                  frame.size.width = [selectedValue floatValue];
                  _box.frame = frame;
                }];

  // Add switch control.
  [RMXRemix addRemixWithKey:@"show"
               usingControl:[RMXSwitch controlWithTitle:@"Show Box"]
              selectedValue:@(YES)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  _box.hidden = ![selectedValue boolValue];
                }];

  // Add button control.
  [RMXRemix addRemixWithKey:@"print"
               usingControl:[RMXButton controlWithTitle:@"Print Session ID"]
              selectedValue:@(YES)
                updateBlock:^(RMXRemix *remix, NSNumber *selectedValue) {
                  NSLog(@"Session id: %@", [[RMXApp sharedInstance] sessionId]);
                }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [RMXRemix removeAllRemixes];
}

@end
