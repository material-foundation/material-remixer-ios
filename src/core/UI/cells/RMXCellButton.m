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

#import "RMXCellButton.h"

#import "RMXRemix.h"

static CGFloat kButtonPaddingLeft = 10.0f;

@implementation RMXCellButton {
  UIButton *_button;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _button = nil;
}

- (void)setRemix:(RMXRemix *)remix {
  [super setRemix:remix];
  if (!remix) {
    return;
  }

  if (!_button) {
    _button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _button.frame = self.controlViewWrapper.bounds;
    _button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_button setTitleEdgeInsets:UIEdgeInsetsMake(0, kButtonPaddingLeft, 0, 0)];
    [_button setImage:RMXResources(RMXIconLaunch) forState:UIControlStateNormal];
    [_button addTarget:self
                  action:@selector(didTapButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [self.controlViewWrapper addSubview:_button];
  }

  [_button setTitle:remix.title forState:UIControlStateNormal];
  self.detailTextLabel.text = @"Action";
}

#pragma mark - Control Events

- (void)didTapButton:(UIButton *)button {
  [self.remix setSelectedValue:@(button.isSelected) fromOverlay:YES];
}

@end
