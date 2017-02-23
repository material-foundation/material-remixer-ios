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

#import "RMXShareSwitchCell.h"

static CGFloat kDetailTextAplha = 0.5f;
static NSString *const kDetailText = @"Values can be adjusted by anyone with the link";
static NSString *const kSharingOnText = @"Sharing is on";
static NSString *const kSharingOffText = @"Sharing is off";

@implementation RMXShareSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor blackColor];
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:kDetailTextAplha];

    self.detailTextLabel.text = kDetailText;

    _switchControl = [[UISwitch alloc] initWithFrame:CGRectZero];
    [_switchControl addTarget:self
                       action:@selector(switchUpdated:)
             forControlEvents:UIControlEventValueChanged];
    self.accessoryView = _switchControl;

    [self updateLabel];
  }
  return self;
}

- (void)switchUpdated:(UISwitch *)switchControl {
  [self.delegate switchControlWasUpdated:switchControl];
  [self updateLabel];
}

- (void)updateLabel {
  self.textLabel.text = _switchControl.isOn ? kSharingOnText : kSharingOffText;
}

@end
