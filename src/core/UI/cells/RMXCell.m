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

#import "RMXCell.h"

const CGFloat RMXCellHeightMinimal = 54.0f;
const CGFloat RMXCellHeightLarge = 76.0f;

static CGFloat kTextAplha = 0.5f;
static CGFloat kDetailTextPaddingTop = 4.0f;
static CGFloat kContainerPaddingTop = 24.0f;
static CGFloat kContainerPaddingEdges = 16.0f;

@implementation RMXCell {
  id<NSObject> _notificationObserver;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor colorWithWhite:0 alpha:kTextAplha];
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:kTextAplha];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (void)setVariable:(RMXVariable *)variable {
  _variable = variable;

  if (!_controlViewWrapper) {
    _controlViewWrapper = [[UIView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_controlViewWrapper];
  }
}

#pragma mark - Layout

- (void)prepareForReuse {
  [super prepareForReuse];

  [_controlViewWrapper removeFromSuperview];
  _controlViewWrapper = nil;
  _variable = nil;
  self.accessoryView = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect containerFrame =
      CGRectMake(kContainerPaddingEdges, kContainerPaddingTop,
                 CGRectGetWidth(self.contentView.bounds) - (kContainerPaddingEdges * 2),
                 [[self class] cellHeight] - kContainerPaddingTop - kContainerPaddingEdges);
  _controlViewWrapper.frame = containerFrame;

  // Position detail text label.
  CGRect detailFrame = self.detailTextLabel.frame;
  detailFrame.origin.y = kDetailTextPaddingTop;
  self.detailTextLabel.frame = detailFrame;
}

@end
