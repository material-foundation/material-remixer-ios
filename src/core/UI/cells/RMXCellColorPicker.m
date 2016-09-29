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

#import "RMXItemListVariable.h"

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

- (void)setVariable:(RMXItemListVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_swatchesContainer) {
    _swatchesContainer = [[UIView alloc] initWithFrame:self.controlViewWrapper.bounds];
    _swatchButtons = [NSMutableArray array];
    CGFloat boundsHeight = CGRectGetHeight(self.controlViewWrapper.bounds);
    for (NSInteger count = 0; count < variable.itemList.count; count++) {
      UIColor *color = variable.itemList[count];
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

  [self updateSelectedIndicator];
  self.detailTextLabel.text = variable.title;
}

#pragma mark - Control Events

- (void)swatchPressed:(UIButton *)button {
  [self.variable setSelectedValue:button.backgroundColor];
  [self.variable save];
  [self updateSelectedIndicator];
}

#pragma mark - Private

- (void)updateSelectedIndicator {
  NSUInteger *selectedIndex = [self.variable.itemList indexOfObject:self.variable.selectedValue];
  if (selectedIndex != NSNotFound) {
    [self selectIndex:selectedIndex];
  }
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
