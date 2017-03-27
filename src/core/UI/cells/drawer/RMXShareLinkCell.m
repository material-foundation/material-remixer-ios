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

#import "RMXShareLinkCell.h"

#import "RMXOverlayResources.h"
#import "RMXRemixer.h"

@implementation RMXShareLinkCell {
  UIButton *_shareLinkButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    _shareLinkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareLinkButton setTitle:@"Share Link"
                      forState:UIControlStateNormal];
    [_shareLinkButton setTitleColor:self.tintColor forState:UIControlStateNormal];
    [_shareLinkButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    _shareLinkButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_shareLinkButton addTarget:self
                         action:@selector(linkButtonWasTapped)
               forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_shareLinkButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _shareLinkButton.frame = self.bounds;
}

#pragma mark - Events

- (void)linkButtonWasTapped {
  [self.delegate shareLinkButtonWasTapped:_shareLinkButton];
}

@end
