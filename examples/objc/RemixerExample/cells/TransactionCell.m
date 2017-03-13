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

#import "TransactionCell.h"

#import "Remixer.h"

@implementation TransactionCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.iconVisible = YES;

    UIImage *image = [[UIImage imageNamed:@"iconStore"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _iconView = [[UIImageView alloc] initWithImage:image];
    _iconView.tintColor = [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    [self.contentView addSubview:_iconView];

    _primaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_primaryLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_primaryLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_primaryLabel];

    _secondaryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_secondaryLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_secondaryLabel setTextColor:[UIColor colorWithWhite:0.54 alpha:1]];
    [self.contentView addSubview:_secondaryLabel];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_priceLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_priceLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_priceLabel];

    [_primaryLabel setText:@"Merchant Name"];
    [_secondaryLabel setText:@"Saturday"];
    [_priceLabel setText:@"$10.99"];

    [RMXColorVariable colorVariableWithKey:@"appTintColor"
                              defaultValue:[UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1]
                           limitedToValues:nil
                               updateBlock:^(RMXColorVariable *variable, UIColor *selectedValue) {
                                 self.iconView.tintColor = selectedValue;
                               }];
    [RMXBooleanVariable booleanVariableWithKey:@"iconVisible"
                                  defaultValue:YES
                                   updateBlock:^(RMXBooleanVariable *variable, BOOL selectedValue) {
                                     self.iconVisible = selectedValue;
                                     [self setNeedsLayout];
                                   }];
  }
  return self;
}

- (void)layoutSubviews {
  [_primaryLabel sizeToFit];
  [_secondaryLabel sizeToFit];
  [_priceLabel sizeToFit];

  if (_iconVisible) {
    _iconView.frame = CGRectMake(20, self.bounds.size.height / 2.0 - 12, 24, 24);
  } else {
    _iconView.frame = CGRectZero;
  }

  _primaryLabel.frame = CGRectMake(CGRectGetMaxX(_iconView.frame) + 20,
                                   self.bounds.size.height / 2.0 - _primaryLabel.frame.size.height / 2.0 - 8,
                                   _primaryLabel.bounds.size.width,
                                   _primaryLabel.bounds.size.height);
  _secondaryLabel.frame = CGRectMake(CGRectGetMinX(_primaryLabel.frame),
                                     CGRectGetMaxY(_primaryLabel.frame) + 2,
                                     _secondaryLabel.bounds.size.width,
                                     _secondaryLabel.bounds.size.height);
  _priceLabel.frame = CGRectMake(self.bounds.size.width - 24 - _priceLabel.frame.size.width,
                                 self.bounds.size.height / 2.0 - _priceLabel.frame.size.height / 2.0,
                                 _priceLabel.frame.size.width,
                                 _priceLabel.frame.size.height);
}

- (void)prepareForReuse {

}

- (void)setIconVisible:(BOOL)iconVisible {
  _iconVisible = iconVisible;
  [self setNeedsLayout];
}

@end
