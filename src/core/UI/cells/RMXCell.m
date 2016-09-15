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
static CGFloat kContainerHeight = 40.0f;

@implementation RMXCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor colorWithWhite:0 alpha:kTextAplha];
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:kTextAplha];
  }
  return self;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (void)setRemix:(RMXRemix *)remix {
  _remix = remix;

  // Add control container view.
  if (!_controlViewWrapper) {
    CGRect containerFrame = CGRectMake(
        kContainerPaddingEdges, kContainerPaddingTop,
        CGRectGetWidth(self.contentView.bounds) - (kContainerPaddingEdges * 2), kContainerHeight);
    _controlViewWrapper = [[UIView alloc] initWithFrame:containerFrame];
    _controlViewWrapper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:_controlViewWrapper];
  }
}

#pragma mark - <RMXRemixDelegate>

- (void)remix:(RMXRemix *)remix didSelectValue:(NSNumber *)selectedValue {
  [self setRemix:remix];
}

#pragma mark - Layout

- (void)prepareForReuse {
  [super prepareForReuse];

  [_controlViewWrapper removeFromSuperview];
  _controlViewWrapper = nil;
  self.remix = nil;
  self.accessoryView = nil;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Position detail text label.
  CGRect detailFrame = self.detailTextLabel.frame;
  detailFrame.origin.y = kDetailTextPaddingTop;
  self.detailTextLabel.frame = detailFrame;
}

#pragma mark - RMXRemixDelegate

- (void)remix:(RMXRemix *)remix wasUpdatedFromBackendToValue:(nonnull id)value {
  [self setRemix:remix];
}

@end
