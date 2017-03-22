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

#import "RMXOverlayTopBarView.h"

#import "RMXCell.h"
#import "RMXOverlayResources.h"
#import "RMXShareLinkCell.h"
#import "RMXShareSwitchCell.h"

@interface RMXOverlayTopBarView () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation RMXOverlayTopBarView {
  UIView *_containerView;
  CAShapeLayer *_maskLayer;
  BOOL _sharing;
}

static CGFloat kButtonHeight = 40.0f;
NSString *const kTitleRemixer = @"Remixer";
NSString *const kSharingLabel = @"SHARING";

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.25;

    _maskLayer = [[CAShapeLayer alloc] init];
    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;

    _containerView = [[UIView alloc] initWithFrame:frame];
    _containerView.layer.mask = _maskLayer;
    [self addSubview: _containerView];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setFrame:CGRectMake(8, 0, kButtonHeight, kButtonHeight)];
    [_closeButton setImage:RMXResources(RMXIconClose) forState:UIControlStateNormal];
    [_closeButton setTintColor:[UIColor blackColor]];
    [_containerView addSubview:_closeButton];

    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:19]];
    _titleLabel.text = kTitleRemixer;
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_containerView addSubview:_titleLabel];

    _drawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawerButton setFrame:CGRectMake(8, 0, kButtonHeight, kButtonHeight)];
    [_drawerButton setImage:RMXResources(RMXIconArrowDown) forState:UIControlStateNormal];
    [_drawerButton setTintColor:[UIColor blackColor]];
    [_drawerButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_drawerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_drawerButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    // Flip image to right.
    _drawerButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _drawerButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _drawerButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [_containerView addSubview:_drawerButton];

    _drawerTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _drawerTable.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    _drawerTable.allowsSelection = NO;
    _drawerTable.backgroundColor = [UIColor whiteColor];
    _drawerTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_containerView addSubview:_drawerTable];

    _drawerTable.dataSource = self;
    _drawerTable.delegate = self;
    _drawerTable.scrollEnabled = NO;
    [_drawerTable registerClass:[RMXShareSwitchCell class]
         forCellReuseIdentifier:NSStringFromClass([RMXShareSwitchCell class])];
    [_drawerTable registerClass:[RMXShareLinkCell class]
         forCellReuseIdentifier:NSStringFromClass([RMXShareLinkCell class])];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  if (!CGRectEqualToRect(_containerView.bounds, self.bounds) &&
      !CGRectIsEmpty(_containerView.bounds)) {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    CGPathRef newPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    animation.fromValue = (id)_maskLayer.path;
    animation.toValue = (__bridge id)newPath;
    animation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = RMXOverlayDrawerAnimationDuration;
    _maskLayer.path = newPath;
    [_maskLayer addAnimation:animation forKey:@"path"];
  } else {
    _maskLayer.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
  }

  _containerView.frame = self.bounds;

  CGFloat closedMidY = RMXOverlayTopBarClosedHeight / 2.0;
  CGRect closeButtonFrame = _closeButton.frame;
  closeButtonFrame.origin.x = 4;
  closeButtonFrame.origin.y = closedMidY - closeButtonFrame.size.height / 2.0;
  _closeButton.frame = closeButtonFrame;
  [_titleLabel sizeToFit];
  _titleLabel.center =
      CGPointMake(CGRectGetMaxX(_closeButton.frame) + 8 + CGRectGetMidX(_titleLabel.bounds),
                  closedMidY);

  CGSize drawerButtonSize = [_drawerButton sizeThatFits:self.bounds.size];
  drawerButtonSize.width += 10;
  CGRect drawerButtonFrame = CGRectMake(self.bounds.size.width - 6 - drawerButtonSize.width,
                                        closedMidY - drawerButtonSize.height / 2.0,
                                        drawerButtonSize.width, drawerButtonSize.height);
  _drawerButton.frame = drawerButtonFrame;

  _drawerTable.frame = CGRectMake(0,
                                  2 * closedMidY,
                                  self.bounds.size.width,
                                  2 * RMXCellHeightMinimal);
}

- (CGSize)sizeThatFits:(CGSize)size {
  size.height = RMXOverlayTopBarClosedHeight + 2 * RMXCellHeightMinimal + 16;
  return size;
}

- (void)displaySharing:(BOOL)sharing {
  _sharing = sharing;
  [_drawerButton setTitle:sharing ? kSharingLabel : @""
                 forState:UIControlStateNormal];
  [self setNeedsLayout];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  switch (indexPath.row) {
    case 0: {
      NSString *identifier = NSStringFromClass([RMXShareSwitchCell class]);
      RMXShareSwitchCell *shareSwitchCell =
          (RMXShareSwitchCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      shareSwitchCell.sharing = _sharing;
      shareSwitchCell.delegate = _shareSwitchCellDelegate;
      cell = shareSwitchCell;
      break;
    }
    case 1: {
      NSString *identifier = NSStringFromClass([RMXShareLinkCell class]);
      RMXShareLinkCell *shareLinkCell =
          (RMXShareLinkCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
      shareLinkCell.delegate = _shareLinkCellDelegate;
      cell = shareLinkCell;
      break;
    }
    default:
      break;
  }
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return RMXCellHeightMinimal;
}

@end
