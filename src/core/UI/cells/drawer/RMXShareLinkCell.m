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

static CGFloat kTextAplha = 0.5f;
static CGFloat kDetailTextPaddingTop = 6.0f;
static CGFloat kHorizontalPadding = 16.0f;
static CGFloat kButtonSize = 32.0f;

@implementation RMXShareLinkCell {
  UIButton *_link;
  UIButton *_shareButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
  if (self) {
    self.detailTextLabel.textColor = [UIColor colorWithWhite:0 alpha:kTextAplha];
    self.detailTextLabel.text = @"Link";

    _link = [UIButton buttonWithType:UIButtonTypeCustom];
    [_link setTitle:[[RMXRemixer remoteControllerURL] absoluteString]
           forState:UIControlStateNormal];
    [_link.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [_link setTitleColor:self.tintColor forState:UIControlStateNormal];
    _link.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_link addTarget:self
              action:@selector(linkButtonWasTapped)
        forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_link];

    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareButton setImage:RMXResources(RMXIconShare) forState:UIControlStateNormal];
    _shareButton.tintColor = [UIColor blackColor];
    [_shareButton addTarget:self
                     action:@selector(shareButtonWasPressed)
           forControlEvents:UIControlEventTouchUpInside];
    self.accessoryView = _shareButton;
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect detailFrame = self.detailTextLabel.frame;
  detailFrame.origin.y = kDetailTextPaddingTop;
  self.detailTextLabel.frame = detailFrame;

  CGRect shareButtonFrame = CGRectMake(self.bounds.size.width - kHorizontalPadding - kButtonSize,
                                       12, kButtonSize, kButtonSize);
  _shareButton.frame = shareButtonFrame;

  [_link sizeToFit];
  CGRect linkFrame = _link.frame;
  linkFrame.origin.x = detailFrame.origin.x;
  linkFrame.origin.y = CGRectGetMaxY(detailFrame) - 4;
  linkFrame.size.width = MIN(linkFrame.size.width,
                             _shareButton.frame.origin.x - linkFrame.origin.x - kHorizontalPadding);
  _link.frame = linkFrame;
}

#pragma mark - Events

- (void)linkButtonWasTapped {
  [self.delegate linkButtonWasTapped:_link];
}

- (void)shareButtonWasPressed {
  [self.delegate shareButtonWasTapped:_shareButton];
}

@end
