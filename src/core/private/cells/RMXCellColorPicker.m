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

#import "RMXCellColorPicker.h"

#import "RMXColorPicker.h"

static CGFloat kSwatchInnerPadding = 10.0f;

@implementation RMXCellColorPicker {
  UIView *_swatchesContainer;
  NSMutableArray<UIButton *> *_swatchButtons;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [_swatchesContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  _swatchesContainer = nil;
  _swatchButtons = nil;
}

- (void)setRemix:(RMXRemix *)remix {
  [super setRemix:remix];
  if (!remix) {
    return;
  }

  RMXColorPicker *remixControl = (RMXColorPicker *)remix.model;
  if (!_swatchesContainer) {
    _swatchesContainer = [[UIView alloc] initWithFrame:self.controlViewWrapper.bounds];
    _swatchButtons = [NSMutableArray array];
    CGFloat boundsHeight = CGRectGetHeight(self.controlViewWrapper.bounds);
    for (NSInteger count = 0; count < remixControl.itemList.count; count++) {
      UIColor *color = remixControl.itemList[count];
      UIButton *swatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
      swatchButton.frame = CGRectMake((count * boundsHeight) + (count * kSwatchInnerPadding), 0,
                                      boundsHeight, boundsHeight);
      swatchButton.layer.cornerRadius = boundsHeight / 2;
      swatchButton.layer.shouldRasterize = YES;
      swatchButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
      swatchButton.backgroundColor = color;
      swatchButton.tintColor = [UIColor whiteColor];
      [swatchButton addTarget:self
                       action:@selector(swatchPressed:)
             forControlEvents:UIControlEventTouchUpInside];
      [_swatchButtons addObject:swatchButton];
      [_swatchesContainer addSubview:swatchButton];
    }
    [self.controlViewWrapper addSubview:_swatchesContainer];
  }

  [self selectIndex:[remix.selectedValue integerValue]];
  self.detailTextLabel.text = remixControl.title;
}

#pragma mark - Control Events

- (void)swatchPressed:(UIButton *)button {
  NSInteger index = [_swatchButtons indexOfObject:button];
  [RMXRemix updateSelectedValue:@(index) forRemix:self.remix shouldSync:YES];
}

- (void)selectIndex:(NSInteger)selectedIndex {
  // Add check image if selected.
  for (NSInteger i = 0; i < _swatchButtons.count; i++) {
    UIButton *swatchButton = _swatchButtons[i];
    UIImage *checkImage = (i == selectedIndex) ? RMXResources(RMXIconCheck) : nil;
    [swatchButton setImage:checkImage forState:UIControlStateNormal];
  }
}

@end
