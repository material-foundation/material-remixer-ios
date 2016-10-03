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

@implementation RMXCellSwitch {
  UISwitch *_switchControl;
}

@dynamic remix;

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _switchControl = nil;
}

- (void)setRemix:(RMXBooleanRemix *)remix {
  [super setRemix:remix];
  if (!remix) {
    return;
  }

  if (!_switchControl) {
    _switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchControl addTarget:self
                       action:@selector(switchUpdated:)
             forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _switchControl;
  }

  _switchControl.on = remix.selectedBooleanValue;
  self.textLabel.text = remix.title;
}

#pragma mark - Control Events

- (void)switchUpdated:(UISwitch *)switchControl {
  [self.remix setSelectedBooleanValue:switchControl.isOn];
  [self.remix save];
}

@end
