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

@interface TransactionDetailsCell ()

@property(nonatomic, strong) UILabel *amountTitleLabel;
@property(nonatomic, strong) CAShapeLayer *firstDividerLayer;
@property(nonatomic, strong) UILabel *dateTitleLabel;
@property(nonatomic, strong) CAShapeLayer *secondDividerLayer;
@property(nonatomic, strong) UILabel *statusTitleLabel;

@end

@implementation TransactionDetailsCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];

    _amountTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_amountTitleLabel];
    _amountValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_amountValueLabel];
    _dateTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_dateTitleLabel];
    _dateValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_dateValueLabel];
    _statusTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_statusTitleLabel];
    _statusValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_statusValueLabel];

    _amountTitleLabel.text = @"AMOUNT";
    _dateTitleLabel.text = @"DATE";
    _statusTitleLabel.text = @"STATUS";

    _firstDividerLayer = [CAShapeLayer layer];
    _secondDividerLayer = [CAShapeLayer layer];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];


}

@end
