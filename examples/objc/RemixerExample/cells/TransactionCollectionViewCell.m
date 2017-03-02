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

#import "TransactionCollectionViewCell.h"

@interface TransactionCollectionViewCell ()

@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *merchantLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *priceLabel;

@end

@implementation TransactionCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    UIImage *image = [[UIImage imageNamed:@"iconStore"]
        imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    _iconView = [[UIImageView alloc] initWithImage:image];
    _iconView.tintColor = [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    [self.contentView addSubview:_iconView];

    _merchantLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_merchantLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_merchantLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_merchantLabel];

    _dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_dateLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_dateLabel setTextColor:[UIColor colorWithWhite:0.54 alpha:1]];
    [self.contentView addSubview:_dateLabel];

    _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_priceLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_priceLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_priceLabel];

    [_merchantLabel setText:@"Merchant Name"];
    [_dateLabel setText:@"Saturday"];
    [_priceLabel setText:@"$10.99"];
  }
  return self;
}

- (void)layoutSubviews {
  [_merchantLabel sizeToFit];
  [_dateLabel sizeToFit];
  [_priceLabel sizeToFit];

  _merchantLabel.frame = CGRectMake(64, 16,
                                    _merchantLabel.bounds.size.width,
                                    _merchantLabel.bounds.size.height);
  _dateLabel.frame = CGRectMake(64, CGRectGetMaxY(_merchantLabel.frame),
                                _dateLabel.bounds.size.width, _dateLabel.bounds.size.height);
  _priceLabel.frame = CGRectMake(self.bounds.size.width - 24 - _priceLabel.frame.size.width,
                                 self.bounds.size.height / 2.0 - _priceLabel.frame.size.height / 2.0,
                                 _priceLabel.frame.size.width, _priceLabel.frame.size.height);

  _iconView.frame = CGRectMake(16, self.bounds.size.height / 2.0 - _iconView.bounds.size.height / 2.0,
                               _iconView.bounds.size.width, _iconView.bounds.size.height);
}

- (void)prepareForReuse {

}

@end
