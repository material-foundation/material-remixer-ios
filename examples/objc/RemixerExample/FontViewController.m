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

#import "FontViewController.h"

#import "Remixer.h"

@implementation FontViewController {
  UILabel *_fontLabel;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  _fontLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  _fontLabel.numberOfLines = 0;
  _fontLabel.textAlignment = NSTextAlignmentCenter;
  [self.view addSubview:_fontLabel];

  [RMXStringVariable stringVariableWithKey:@"labelText"
                              defaultValue:@"This is a customizable label"
                               updateBlock:^(RMXStringVariable *variable, NSString *selectedValue) {
                                 _fontLabel.text = selectedValue;
                                 [self.view setNeedsLayout];
                               }];

  NSArray<NSString *> *fontNames = @[
    @"System", @"AvenirNext-Bold", @"Baskerville-SemiBold", @"Courier",
    @"Futura-CondensedExtraBold", @"Helvetica-Light", @"SnellRoundhand"
  ];
  [RMXStringVariable
      stringVariableWithKey:@"labelFont"
               defaultValue:fontNames[1]
             possibleValues:fontNames
                updateBlock:^(RMXStringVariable *variable, NSString *selectedFontName) {
                  _fontLabel.font =
                      [UIFont fontWithName:selectedFontName size:_fontLabel.font.pointSize];
                  [self.view setNeedsLayout];
                }];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  CGSize labelSize = [_fontLabel sizeThatFits:CGRectInset(self.view.bounds, 20, 100).size];
  _fontLabel.frame = CGRectMake(20, 100, self.view.bounds.size.width - 40, labelSize.height);
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [RMXRemixer removeAllVariables];
}

@end
