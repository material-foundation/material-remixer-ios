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

#import "HeaderStatsView.h"

@interface HeaderStatsView ()

@property(nonatomic, strong) UILabel *amountLabel;
@property(nonatomic, strong) UILabel *timePeriodLabel;

@end

@implementation HeaderStatsView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _amountLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_amountLabel setFont:[UIFont systemFontOfSize:22.0]];
    [_amountLabel setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    [_amountLabel setText:@"$201.99"];
    [self addSubview:_amountLabel];
    _timePeriodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_timePeriodLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_timePeriodLabel setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    [_timePeriodLabel setText:@"THIS MONTH"];
    [self addSubview:_timePeriodLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [_amountLabel setFont:[UIFont systemFontOfSize:round(self.bounds.size.height / 4)]];

  [_amountLabel sizeToFit];
  [_timePeriodLabel sizeToFit];

  CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  _amountLabel.frame = CGRectMake(center.x - _amountLabel.bounds.size.width / 2.0,
                                  center.y -_amountLabel.bounds.size.height,
                                  _amountLabel.bounds.size.width,
                                  _amountLabel.bounds.size.height);
  _timePeriodLabel.frame = CGRectMake(center.x - _timePeriodLabel.bounds.size.width / 2.0,
                                      center.y + 2,
                                      _timePeriodLabel.bounds.size.width,
                                      _timePeriodLabel.bounds.size.height);
}

- (void)setAmountValue:(NSString *)amountValue {
  [_amountLabel setText:amountValue];
}

- (NSString *)amountValue {
  return [_amountLabel text];
}

- (void)setTimePeriod:(NSString *)timePeriod {
  [_timePeriodLabel setText:timePeriod];
}

- (NSString *)timePeriod {
  return [_timePeriodLabel text];
}

@end
