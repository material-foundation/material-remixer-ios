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

#import "TransactionDetailsCell.h"

#import "Remixer.h"

@interface TransactionDetailsCell ()

@property(nonatomic, strong) UILabel *amountTitleLabel;
@property(nonatomic, strong) UILabel *amountValueLabel;
@property(nonatomic, strong) CAShapeLayer *firstDividerLayer;
@property(nonatomic, strong) UILabel *dateTitleLabel;
@property(nonatomic, strong) UILabel *dateValueLabel;
@property(nonatomic, strong) CAShapeLayer *secondDividerLayer;
@property(nonatomic, strong) UILabel *statusTitleLabel;
@property(nonatomic, strong) UILabel *statusValueLabel;

@end

@implementation TransactionDetailsCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _amountTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_amountTitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_amountTitleLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_amountTitleLabel];
    _amountValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_amountValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_amountValueLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_amountValueLabel];
    _dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_dateTitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_dateTitleLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_dateTitleLabel];
    _dateValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_dateValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_dateValueLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_dateValueLabel];
    _statusTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_statusTitleLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_statusTitleLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_statusTitleLabel];
    _statusValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_statusValueLabel setFont:[UIFont systemFontOfSize:17.0]];
    [_statusValueLabel setTextColor:[UIColor colorWithWhite:0.231 alpha:1]];
    [self.contentView addSubview:_statusValueLabel];

    _amountTitleLabel.text = @"AMOUNT";
    _amountValueLabel.text = @"$9.90";
    _dateTitleLabel.text = @"DATE";
    _dateValueLabel.text = @"Jan 1, 2017";
    _statusTitleLabel.text = @"STATUS";
    _statusValueLabel.text = @"Pending";

    _firstDividerLayer = [CAShapeLayer layer];
    _firstDividerLayer.fillColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    [self.layer addSublayer:_firstDividerLayer];
    _secondDividerLayer = [CAShapeLayer layer];
    _secondDividerLayer.fillColor = [UIColor colorWithWhite:0.85 alpha:1].CGColor;
    [self.layer addSublayer:_secondDividerLayer];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  [_amountTitleLabel sizeToFit];
  [_amountValueLabel sizeToFit];
  [_dateTitleLabel sizeToFit];
  [_dateValueLabel sizeToFit];
  [_statusTitleLabel sizeToFit];
  [_statusValueLabel sizeToFit];

  _dateTitleLabel.frame = CGRectMake(24,
                                     CGRectGetMidY(self.bounds) - round(CGRectGetMidY(_dateTitleLabel.bounds)),
                                     _dateTitleLabel.bounds.size.width,
                                     _dateTitleLabel.bounds.size.height);

  _amountTitleLabel.frame = CGRectMake(24,
                                       CGRectGetMinY(_dateTitleLabel.frame) - 12 * 2 - _amountTitleLabel.bounds.size.height,
                                       _amountTitleLabel.bounds.size.width,
                                       _amountTitleLabel.bounds.size.height);

  _statusTitleLabel.frame = CGRectMake(24,
                                       CGRectGetMaxY(_dateTitleLabel.frame) + 12 * 2,
                                       _statusTitleLabel.bounds.size.width,
                                       _statusTitleLabel.bounds.size.height);

  _firstDividerLayer.frame = CGRectMake(24, CGRectGetMinY(_dateTitleLabel.frame) - 12, self.bounds.size.width - 24 * 2, 0.5);
  _firstDividerLayer.path = [UIBezierPath bezierPathWithRect:_firstDividerLayer.bounds].CGPath;

  _secondDividerLayer.frame = CGRectMake(24, CGRectGetMaxY(_dateTitleLabel.frame) + 12, self.bounds.size.width - 24 * 2, 0.5);
  _secondDividerLayer.path = [UIBezierPath bezierPathWithRect:_secondDividerLayer.bounds].CGPath;

  _amountValueLabel.frame =
      CGRectMake(CGRectGetMaxX(_firstDividerLayer.frame) - _amountValueLabel.bounds.size.width,
                 CGRectGetMidY(_amountTitleLabel.frame) - CGRectGetMidY(_amountValueLabel.bounds),
                 _amountValueLabel.bounds.size.width,
                 _amountValueLabel.bounds.size.height);
  _dateValueLabel.frame =
      CGRectMake(CGRectGetMaxX(_firstDividerLayer.frame) - _dateValueLabel.bounds.size.width,
                 CGRectGetMidY(_dateTitleLabel.frame) - CGRectGetMidY(_dateValueLabel.bounds),
                 _dateValueLabel.bounds.size.width,
                 _dateValueLabel.bounds.size.height);
  _statusValueLabel.frame =
      CGRectMake(CGRectGetMaxX(_firstDividerLayer.frame) - _statusValueLabel.bounds.size.width,
                 CGRectGetMidY(_statusTitleLabel.frame) - CGRectGetMidY(_statusValueLabel.bounds),
                 _statusValueLabel.bounds.size.width,
                 _statusValueLabel.bounds.size.height);
}

@end
