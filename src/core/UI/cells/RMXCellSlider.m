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

#import "RMXCellSlider.h"

@implementation RMXCellSlider {
  UISlider *_sliderControl;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _sliderControl = nil;
}

- (void)setVariable:(RMXRangeVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_sliderControl) {
    _sliderControl = [[UISlider alloc] initWithFrame:CGRectZero];
    [_sliderControl addTarget:self
                       action:@selector(sliderUpdated:)
             forControlEvents:UIControlEventValueChanged];
    [_sliderControl addTarget:self
                       action:@selector(sliderUpdateComplete:)
             forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.controlViewWrapper addSubview:_sliderControl];
  }

  _sliderControl.minimumValueImage = [self imageFromFloatValue:variable.minimumValue];
  _sliderControl.maximumValueImage = [self imageFromFloatValue:variable.maximumValue];
  _sliderControl.minimumValue = (float)variable.minimumValue;
  _sliderControl.maximumValue = (float)variable.maximumValue;
  _sliderControl.value = (float)variable.selectedFloatValue;

  [self updateDetailLabel];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _sliderControl.frame = self.controlViewWrapper.bounds;
}

#pragma mark - Control Events

- (void)sliderUpdated:(UISlider *)sliderControl {
  // Continuously update slider, but do not save changes.
  [self.variable setSelectedFloatValue:sliderControl.value];
  [self updateDetailLabel];
}

- (void)sliderUpdateComplete:(UISlider *)sliderControl {
  [self.variable setSelectedFloatValue:sliderControl.value];
  [self.variable save];
  [self updateDetailLabel];
}

#pragma mark - Private

- (void)updateDetailLabel {
  self.detailTextLabel.text =
      [NSString stringWithFormat:@"%@ (%.2f)", self.variable.title, _sliderControl.value];
}

- (UIImage *)imageFromFloatValue:(CGFloat)floatValue {
  NSString *text = [NSString stringWithFormat:@"%.1f", floatValue];
  NSDictionary *attributes = @{NSFontAttributeName : self.detailTextLabel.font};
  CGSize size = [text sizeWithAttributes:attributes];

  // Return image made from provided float and font.
  UIGraphicsBeginImageContextWithOptions(size, NO, 0);
  [text drawAtPoint:CGPointZero withAttributes:attributes];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return image;
}

@end
