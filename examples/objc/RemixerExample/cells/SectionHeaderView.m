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

#import "SectionHeaderView.h"

@implementation SectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0 weight:UIFontWeightUltraLight]];
    [_titleLabel setTextColor:[UIColor colorWithWhite:0.5 alpha:1]];
    [self addSubview:_titleLabel];
  }
  return self;
}

- (void)layoutSubviews {
  [_titleLabel sizeToFit];
  _titleLabel.frame = CGRectMake(16, self.bounds.size.height / 2.0 - _titleLabel.bounds.size.height / 2.0,
                                 _titleLabel.bounds.size.width, _titleLabel.bounds.size.height);
}

@end
