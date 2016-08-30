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

#import "RMXSlider.h"

@implementation RMXCellSlider {
  UISlider *_sliderControl;
}

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _sliderControl = nil;
}

- (void)setRemix:(RMXRemix *)remix {
  [super setRemix:remix];
  if (!remix) {
    return;
  }

  if (!_sliderControl) {
    _sliderControl = [[UISlider alloc] initWithFrame:self.controlViewWrapper.bounds];
    _sliderControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_sliderControl addTarget:self
                       action:@selector(sliderUpdated:)
             forControlEvents:UIControlEventValueChanged];
    [_sliderControl addTarget:self
                       action:@selector(sliderUpdateComplete:)
             forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [self.controlViewWrapper addSubview:_sliderControl];
  }

  RMXSlider *remixControl = (RMXSlider *)remix.model;
  _sliderControl.minimumValueImage = [self imageFromFloatValue:remixControl.minimumValue];
  _sliderControl.maximumValueImage = [self imageFromFloatValue:remixControl.maximumValue];
  _sliderControl.minimumValue = remixControl.minimumValue;
  _sliderControl.maximumValue = remixControl.maximumValue;
  _sliderControl.value = [remix.selectedValue floatValue];

  self.detailTextLabel.text =
      [NSString stringWithFormat:@"%@ (%.2f)", remixControl.title, _sliderControl.value];
}

#pragma mark - Private helper methods

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

#pragma mark - Control Events

- (void)sliderUpdated:(UISlider *)sliderControl {
  // Continuously update slider, but do not commit changes.
  [RMXRemix updateSelectedValue:@(sliderControl.value) forRemix:self.remix shouldSync:NO];
}

- (void)sliderUpdateComplete:(UISlider *)sliderControl {
  // Commit value only after slider update complete.
  [self.remix commit];
  [self.remix sync];
}

@end
