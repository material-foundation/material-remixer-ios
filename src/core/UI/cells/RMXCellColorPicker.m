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

#import "RMXOverlayWindow.h"
#import "RMXRemixer.h"

static CGFloat kTextPaddingLeft = 18.0f;
static CGFloat kTextPaddingTop = 11.0f;
static CGFloat kColorPreviewWidth = 10.0f;
static CGFloat kButtonTopOffset = -12.0f;

@implementation RMXCellColorPicker {
  UIView *_colorPreview;
  UIButton *_button;
}

@dynamic variable;

+ (CGFloat)cellHeight {
  return RMXCellHeightMinimal;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.textLabel.textColor = [UIColor colorWithWhite:0 alpha:1];
  }
  return self;
}

- (void)setVariable:(RMXColorVariable *)variable {
  [super setVariable:variable];
  if (!variable) {
    return;
  }

  if (!_button) {
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"Edit" forState:UIControlStateNormal];
    [_button addTarget:self
                  action:@selector(didTapButton:)
        forControlEvents:UIControlEventTouchUpInside];
    _button.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    [self.controlViewWrapper addSubview:_button];
  }

  if (!_colorPreview) {
    _colorPreview = [[UIView alloc] initWithFrame:CGRectZero];
    _colorPreview.layer.borderWidth = 1.0;
    _colorPreview.layer.borderColor = [UIColor blackColor].CGColor;
    [self.controlViewWrapper addSubview:_colorPreview];
  }

  _colorPreview.backgroundColor = self.variable.selectedValue;
  self.textLabel.text = [self hexStringFromColor:self.variable.selectedValue];
  self.detailTextLabel.text = self.variable.title;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  _colorPreview.frame =
      CGRectMake(0, 0, kColorPreviewWidth, CGRectGetHeight(self.controlViewWrapper.frame));

  CGRect frame = self.textLabel.frame;
  frame.origin.x += kTextPaddingLeft;
  frame.origin.y += kTextPaddingTop;
  self.textLabel.frame = frame;

  [_button sizeToFit];
  _button.frame =
      CGRectMake(CGRectGetWidth(self.controlViewWrapper.frame) - CGRectGetWidth(_button.frame),
                 kButtonTopOffset,
                 CGRectGetWidth(_button.frame),
                 CGRectGetHeight(_button.frame));
}

- (void)prepareForReuse {
  [super prepareForReuse];

  _button = nil;
  _colorPreview = nil;
}

#pragma mark - Control Events

- (void)didTapButton:(UIButton *)button {
  UIAlertController *alertController =
      [UIAlertController alertControllerWithTitle:@"Enter the HEX value"
                                          message:nil
                                   preferredStyle:UIAlertControllerStyleAlert];
  [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
    textField.placeholder = @"e.g. FF4499";
  }];
  UIAlertAction *saveAction =
      [UIAlertAction actionWithTitle:@"Save"
                               style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction *_Nonnull action) {
                               UITextField *textField = alertController.textFields[0];
                               NSString *textInput = textField.text;
                               if (textInput.length < 6) {
                                 // Error
                                 return;
                               } else if ([[textInput substringToIndex:1] isEqualToString:@"#"]) {
                                 textInput = [textInput substringFromIndex:1];
                               }
                               UIColor *color = [self colorFromHexString:textInput];
                               if (!color) {
                                 // Error
                                 return;
                               } else {
                                 [self.variable setSelectedValue:color];
                                 [self.variable save];
                               }
                             }];
  [alertController addAction:saveAction];
  UIAlertAction *cancelAction =
      [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  [alertController addAction:cancelAction];

  UIViewController *vc = [[RMXRemixer overlayWindow] rootViewController];
  [vc presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - Private

- (NSString *)hexStringFromColor:(UIColor *)color {
  CGFloat rgba[4];
  CGFloat wa[2];
  if ([color getRed:rgba green:rgba + 1 blue:rgba + 2 alpha:rgba + 3]) {
  } else if ([color getWhite:wa alpha:wa + 1]) {
    // Grayscale
    rgba[0] = rgba[1] = rgba[2] = wa[0];
    rgba[3] = wa[1];
  }

  // Convert range from [0, 1] to [0, 255].
  unsigned long red = round(rgba[0] * 255.0);
  unsigned long green = round(rgba[1] * 255.0);
  unsigned long blue = round(rgba[2] * 255.0);

  return [[NSString stringWithFormat:@"#%02lx%02lx%02lx", red, green, blue] uppercaseString];
}

- (nullable UIColor *)colorFromHexString:(NSString *)hexString {
  if (hexString.length < 6) {
    return nil;
  }
  NSScanner *hexScanner;
  unsigned int r, g, b;

  hexScanner = [NSScanner scannerWithString:[hexString substringToIndex:2]];
  [hexScanner scanHexInt:&r];
  hexString = [hexString substringFromIndex:2];
  hexScanner = [NSScanner scannerWithString:[hexString substringToIndex:2]];
  [hexScanner scanHexInt:&g];
  hexString = [hexString substringFromIndex:2];
  hexScanner = [NSScanner scannerWithString:[hexString substringToIndex:2]];
  [hexScanner scanHexInt:&b];

  return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
}

@end
