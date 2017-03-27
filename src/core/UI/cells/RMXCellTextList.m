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

#import "RMXCellTextList.h"

#import "RMXOverlayWindow.h"
#import "RMXRemixer+Private.h"

/** Provide return chars to force padding within UIAlertController. */
NSString *const kAlertStringPadding = @"\n\n\n\n\n\n\n\n\n\n";

static CGFloat kPickerPadding = 20.0f;
static CGFloat kPickerheight = 200.0f;

@interface RMXCellTextList () <UIPickerViewDelegate, UIPickerViewDataSource>
@end

@implementation RMXCellTextList {
  UIButton *_pickerButton;
  UIView *_bottomBorder;
  UIAlertController *_alertController;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightLarge;
}

- (void)setVariable:(RMXStringVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_pickerButton) {
    _pickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pickerButton.frame = CGRectZero;
    _pickerButton.tintColor = [UIColor blackColor];
    _pickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_pickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_pickerButton setImage:RMXResources(RMXIconDropDown) forState:UIControlStateNormal];

    // Add bottom border.
    _bottomBorder = [[UIView alloc] initWithFrame:CGRectZero];
    _bottomBorder.backgroundColor = [UIColor blackColor];
    [_pickerButton addSubview:_bottomBorder];

    // Flip image to right.
    _pickerButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _pickerButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _pickerButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [_pickerButton addTarget:self
                      action:@selector(pickerPressed:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.controlViewWrapper addSubview:_pickerButton];
  }

  [self updateSelectedIndicator];
  self.detailTextLabel.text = variable.title;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _pickerButton.frame = self.controlViewWrapper.bounds;
  _bottomBorder.frame = CGRectMake(0, CGRectGetHeight(_pickerButton.bounds) - 1.0,
                                   CGRectGetWidth(self.controlViewWrapper.bounds), 1.0);
}

- (void)prepareForReuse {
  [super prepareForReuse];
  _pickerButton = nil;
}

#pragma mark - Control Events

- (void)pickerPressed:(UIButton *)pickerButton {
  // Present picker view in an alert controller.
  _alertController = [UIAlertController alertControllerWithTitle:self.variable.title
                                                         message:kAlertStringPadding
                                                  preferredStyle:UIAlertControllerStyleActionSheet];
  UIPickerView *picker = [[UIPickerView alloc]
      initWithFrame:CGRectMake(0, kPickerPadding, self.frame.size.width - (kPickerPadding * 2),
                               kPickerheight)];
  picker.dataSource = self;
  picker.delegate = self;
  NSInteger selectedIndex =
      [self.variable.limitedToValues indexOfObject:self.variable.selectedValue];
  if (selectedIndex == NSNotFound) {
    selectedIndex = self.variable.limitedToValues.count;
  }
  [picker selectRow:selectedIndex inComponent:0 animated:NO];
  [_alertController.view addSubview:picker];
  UIAlertAction *action =
      [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [_alertController addAction:action];
  UIViewController *vc = [[RMXRemixer overlayWindow] rootViewController];
  [vc presentViewController:_alertController animated:YES completion:nil];
}

#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  NSUInteger selectedIndex =
      [self.variable.limitedToValues indexOfObject:self.variable.selectedValue];
  if (selectedIndex != NSNotFound) {
    return self.variable.limitedToValues.count;
  }
  return self.variable.limitedToValues.count + 1;
}

#pragma mark - <UIPickerViewDelegate>

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  if ((NSUInteger)row == self.variable.limitedToValues.count) {
    return self.variable.selectedValue;
  } else {
    return [self.variable.limitedToValues objectAtIndex:row];
  }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row
       inComponent:(NSInteger)component {
  if ((NSUInteger)row < self.variable.limitedToValues.count) {
    [self.variable setSelectedValue:[self.variable.limitedToValues objectAtIndex:row]];
    [self.variable save];
  }
  [self updateSelectedIndicator];
  [_alertController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)updateSelectedIndicator {
  [_pickerButton setTitle:self.variable.selectedValue forState:UIControlStateNormal];
}

@end
