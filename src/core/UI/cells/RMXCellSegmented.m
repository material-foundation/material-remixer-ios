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

#import "RMXCellSegmented.h"

@implementation RMXCellSegmented {
  UISegmentedControl *_segmentControl;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _segmentControl = nil;
}

- (void)setVariable:(RMXVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  NSUInteger selectedIndex = [variable.possibleValues indexOfObject:variable.selectedValue];
  if (selectedIndex != NSNotFound) {
    _segmentControl = [[UISegmentedControl alloc] initWithItems:variable.possibleValues];
  } else {
    NSMutableArray *allValues = [variable.possibleValues mutableCopy];
    [allValues addObject:variable.selectedValue];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:allValues];
  }
  [_segmentControl addTarget:self
                      action:@selector(segmentUpdated:)
            forControlEvents:UIControlEventValueChanged];
  [self.controlViewWrapper addSubview:_segmentControl];

  [self updateSelectedIndicator];
  self.detailTextLabel.text = variable.title;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  _segmentControl.frame = self.controlViewWrapper.bounds;
}

#pragma mark - Control Events

- (void)segmentUpdated:(UISegmentedControl *)segmentControl {
  id newValue = [self.variable.possibleValues objectAtIndex:segmentControl.selectedSegmentIndex];
  [self.variable setSelectedValue:newValue];
  [self.variable save];
  [self updateSelectedIndicator];
}

#pragma mark - Private

- (void)updateSelectedIndicator {
  NSUInteger selectedIndex =
      [self.variable.possibleValues indexOfObject:self.variable.selectedValue];
  if (selectedIndex != NSNotFound) {
    _segmentControl.selectedSegmentIndex = selectedIndex;
  } else {
    _segmentControl.selectedSegmentIndex = self.variable.possibleValues.count;
  }
}

@end
