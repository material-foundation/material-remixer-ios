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

#import "RMXCellColorList.h"

static CGFloat kSwatchInnerPadding = 10.0f;
static CGFloat kMinLuminenceForLightColor = 0.5;

@implementation RMXCellColorList {
  UIView *_swatchesContainer;
  NSMutableArray<UIButton *> *_swatchButtons;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  [_swatchesContainer.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
  _swatchesContainer = nil;
  _swatchButtons = nil;
}

- (void)setVariable:(RMXColorVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  for (UIButton *button in _swatchButtons) {
    [button removeFromSuperview];
  }
  if (_swatchesContainer) {
    [_swatchesContainer removeFromSuperview];
  }

  _swatchesContainer = [[UIView alloc] initWithFrame:self.controlViewWrapper.bounds];
  _swatchButtons = [NSMutableArray array];
  CGFloat boundsHeight = CGRectGetHeight(self.controlViewWrapper.bounds);
  for (NSUInteger count = 0; count < variable.possibleValues.count; count++) {
    UIColor *color = variable.possibleValues[count];
    [self addButtonForColor:color atPosition:count];
  }
  NSUInteger selectedIndex =
      [self.variable.possibleValues indexOfObject:self.variable.selectedValue];
  if (selectedIndex == NSNotFound) {
    UIColor *color = self.variable.selectedValue;
    [self addButtonForColor:color atPosition:self.variable.possibleValues.count];
  }
  [self.controlViewWrapper addSubview:_swatchesContainer];

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

- (void)addButtonForColor:(UIColor *)color atPosition:(NSUInteger)position {
  CGFloat boundsHeight = CGRectGetHeight(self.controlViewWrapper.bounds);
  UIButton *swatchButton = [UIButton buttonWithType:UIButtonTypeCustom];
  swatchButton.frame = CGRectMake((position * boundsHeight) + (position * kSwatchInnerPadding),
                                  0,
                                  boundsHeight,
                                  boundsHeight);
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

- (void)updateSelectedIndicator {
  NSUInteger selectedIndex =
      [self.variable.possibleValues indexOfObject:self.variable.selectedValue];
  if (selectedIndex != NSNotFound) {
    [self selectIndex:selectedIndex];
  } else {
    // If it's not in the possibleValues array then it's the extra one we added for selectedValue.
    [self selectIndex:_swatchButtons.count - 1];
  }
}

- (void)selectIndex:(NSUInteger)selectedIndex {
  // Add check image if selected.
  for (NSUInteger i = 0; i < _swatchButtons.count; i++) {
    UIButton *swatchButton = _swatchButtons[i];
    UIImage *checkImage = (i == selectedIndex) ? RMXResources(RMXIconCheck) : nil;
    [swatchButton setImage:checkImage forState:UIControlStateNormal];
    swatchButton.tintColor = [UIColor whiteColor];
    if (checkImage) {
      // Make the check black if the color is light.
      CGFloat red, green, blue, alpha;
      [swatchButton.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
      // Percieved luminence: https://www.w3.org/TR/AERT#color-contrast
      CGFloat luminence = 0.299 * red + 0.587 * green + 0.114 * blue;
      if (luminence > kMinLuminenceForLightColor) {
        swatchButton.tintColor = [UIColor blackColor];
      }
    }
  }
}

@end
