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
  [RMXItemListVariable
      addItemListVariableWithKey:@"colorPicker"
                    defaultValue:colorOptions[0]
                        itemList:colorOptions
                     updateBlock:^(RMXVariable *_Nonnull variable, id selectedValue) {
                       _box.backgroundColor = selectedValue;
                     }];
  
  // Add segment control.
  NSArray *themesOptions = @[ @"Light", @"Dark" ];
  [RMXItemListVariable
      addItemListVariableWithKey:@"theme"
                    defaultValue:themesOptions[0]
                        itemList:themesOptions
                     updateBlock:^(RMXVariable *_Nonnull variable, id selectedValue) {
                       self.view.backgroundColor = ([selectedValue isEqualToString:@"Light"])
                           ? [UIColor whiteColor] : [UIColor darkGrayColor];
                     }];
  
  // Add slider control.
  [RMXRangeVariable
      addRangeVariableWithKey:@"alpha"
                 defaultValue:1
                     minValue:0
                     maxValue:1
                  updateBlock:^(RMXVariable *_Nonnull variable, CGFloat selectedValue) {
                    _box.alpha = selectedValue;
                  }];
  
  // Add stepper control.
  [RMXRangeVariable
      addRangeVariableWithKey:@"width"
                 defaultValue:80
                     minValue:40
                     maxValue:200
                    increment:20
                  updateBlock:^(RMXVariable *_Nonnull variable, CGFloat selectedValue) {
                    CGRect frame = _box.frame;
                    frame.size.width = selectedValue;
                    _box.frame = frame;
                  }];
  
  // Add switch control.
  [RMXBooleanVariable
      addBooleanVariableWithKey:@"show"
                   defaultValue:YES
                    updateBlock:^(RMXVariable *_Nonnull variable, BOOL selectedValue) {
                      _box.hidden = !selectedValue;
                    }];
  
  // TODO(chuga): Add a Trigger Remix for printing the session ID.
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [RMXRemixer removeAllVariables];
}

@end
