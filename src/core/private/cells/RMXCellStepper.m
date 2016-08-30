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

#import "RMXCellStepper.h"

#import "RMXStepper.h"

@implementation RMXCellStepper {
  UIStepper *_stepperControl;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _stepperControl = nil;
}

- (void)setRemix:(RMXRemix *)remix {
  [super setRemix:remix];
  if (!remix) {
    return;
  }

  if (!_stepperControl) {
    _stepperControl = [[UIStepper alloc] initWithFrame:CGRectZero];
    [_stepperControl addTarget:self
                        action:@selector(stepperUpdated:)
              forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _stepperControl;
  }

  RMXStepper *remixControl = (RMXStepper *)remix.model;
  _stepperControl.minimumValue = remixControl.minimumValue;
  _stepperControl.maximumValue = remixControl.maximumValue;
  _stepperControl.stepValue = remixControl.stepValue;
  _stepperControl.value = [remix.selectedValue floatValue];

  self.textLabel.text = remixControl.title;
}

#pragma mark - Control Events

- (void)stepperUpdated:(UIStepper *)stepperControl {
  [RMXRemix updateSelectedValue:@(stepperControl.value) forRemix:self.remix shouldSync:YES];
}

@end
