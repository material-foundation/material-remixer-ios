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


#import "MerchantDetailsHeaderView.h"

#import "HeaderStatsView.h"

@implementation MerchantDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor =
        [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    _thisMonthStats = [[HeaderStatsView alloc] initWithFrame:CGRectZero];
    _thisMonthStats.timePeriod = @"THIS MONTH";
    _thisMonthStats.amountValue = @"$201.99";
    [self addSubview:_thisMonthStats];
    _thisYearStats = [[HeaderStatsView alloc] initWithFrame:CGRectZero];
    _thisYearStats.timePeriod = @"THIS YEAR";
    _thisYearStats.amountValue = @"$1,092.32";
    [self addSubview:_thisYearStats];
  }
  return self;
}

- (void)layoutSubviews {
  _thisMonthStats.frame = CGRectMake(0,
                                     54,
                                     self.bounds.size.width / 2.0,
                                     self.bounds.size.height - 54);
  _thisYearStats.frame = CGRectMake(self.bounds.size.width / 2.0,
                                    54,
                                    self.bounds.size.width / 2.0,
                                    self.bounds.size.height - 54);
}

@end

