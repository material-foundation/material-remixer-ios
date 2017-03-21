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

#import "RMXCellSwitch.h"

static CGFloat kTextPaddingTop = 10.0f;

@implementation RMXCellSwitch {
  UISwitch *_switchControl;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _switchControl = nil;
}

- (void)setVariable:(RMXBooleanVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_switchControl) {
    _switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchControl addTarget:self
                       action:@selector(switchUpdated:)
             forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _switchControl;
  }

  _switchControl.on = variable.selectedBooleanValue;
  self.textLabel.text = _switchControl.on ? @"ON" : @"OFF";
  self.detailTextLabel.text = variable.title;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect frame = self.textLabel.frame;
  frame.origin.y += kTextPaddingTop;
  self.textLabel.frame = frame;
}

#pragma mark - Control Events

- (void)switchUpdated:(UISwitch *)switchControl {
  self.textLabel.text = _switchControl.on ? @"ON" : @"OFF";
  [self.variable setSelectedBooleanValue:switchControl.isOn];
  [self.variable save];
}

@end
