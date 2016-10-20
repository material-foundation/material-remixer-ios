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

#import "RMXRangeVariable.h"

static CGFloat kTextPaddingTop = 10.0f;

static CGFloat kDefaultMinValue = -100.0f;
static CGFloat kDefaultMaxValue = 100.0f;
static CGFloat kDefaultIncrementValue = 1;

@implementation RMXCellStepper {
  UIStepper *_stepperControl;
}

@dynamic variable;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
  }
  return self;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _stepperControl = nil;
}

- (void)setVariable:(RMXNumberVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_stepperControl) {
    _stepperControl = [[UIStepper alloc] initWithFrame:CGRectZero];
    [_stepperControl addTarget:self
                        action:@selector(stepperUpdated:)
              forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _stepperControl;
  }

  if ([self.variable isKindOfClass:[RMXRangeVariable class]]) {
    RMXRangeVariable *rangeVariable = (RMXRangeVariable *)self.variable;
    _stepperControl.minimumValue = rangeVariable.minimumValue;
    _stepperControl.maximumValue = rangeVariable.maximumValue;
    _stepperControl.stepValue = rangeVariable.increment;
  } else {
    _stepperControl.minimumValue = kDefaultMinValue;
    _stepperControl.maximumValue = kDefaultMaxValue;
    _stepperControl.stepValue = kDefaultIncrementValue;
  }
  _stepperControl.value = [variable.selectedValue doubleValue];

  self.textLabel.text = [NSString stringWithFormat:@"%.2f", variable.selectedFloatValue];
  self.detailTextLabel.text = variable.title;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect frame = self.textLabel.frame;
  frame.origin.y += kTextPaddingTop;
  self.textLabel.frame = frame;
}

#pragma mark - Control Events

- (void)stepperUpdated:(UIStepper *)stepperControl {
  [self.variable setSelectedFloatValue:stepperControl.value];
  [self.variable save];
}

@end
