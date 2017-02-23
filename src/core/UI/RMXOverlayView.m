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

#import "RMXOverlayView.h"

#import "RMXOverlayTopBarView.h"

static CGFloat kDefaultOptionsViewHeight = 260.0f;

@implementation RMXOverlayView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _isDrawerOpen = NO;
    _panelHeight = kDefaultOptionsViewHeight;

    _panelContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_panelContainerView];

    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.contentInset = UIEdgeInsetsMake(-24, 0, 0, 0);
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [_panelContainerView addSubview:_tableView];

    _topBar = [[RMXOverlayTopBarView alloc] initWithFrame:CGRectZero];
    [_panelContainerView addSubview:_topBar];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGSize boundsSize = self.bounds.size;
  _panelContainerView.frame =
      CGRectMake(0, boundsSize.height - _panelHeight, boundsSize.width, _panelHeight);

  CGFloat topBarHeight = _isDrawerOpen ?
      [_topBar sizeThatFits:self.bounds.size].height : RMXOverlayTopBarClosedHeight;
  _topBar.frame = CGRectMake(0, 0, boundsSize.width, topBarHeight);

  CGFloat tableViewHeight = _panelHeight - topBarHeight;
  _tableView.frame = CGRectMake(0, topBarHeight, boundsSize.width, tableViewHeight);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  CGPoint adjustedPoint = [_panelContainerView convertPoint:point fromView:self];
  BOOL pointInsidePanel = [_panelContainerView pointInside:adjustedPoint withEvent:event];
  return pointInsidePanel;
}

- (UIButton *)closeButton {
  return _topBar.closeButton;
}

- (UIButton *)drawerButton {
  return _topBar.drawerButton;
}

- (UITableView *)drawerTable {
  return _topBar.drawerTable;
}

- (void)showAtDefaultHeight {
  _panelHeight = kDefaultOptionsViewHeight;
  [self setNeedsLayout];
}

- (void)showMinimized {
  _panelHeight = RMXOverlayTopBarClosedHeight;
  [self setNeedsLayout];
}

- (void)showMaximized {
  _panelHeight = self.bounds.size.height;
  [self setNeedsLayout];
}

- (void)hidePanel {
  _panelHeight = 0;
  [self setNeedsLayout];
}

- (void)toggleDrawer {
  _isDrawerOpen = !_isDrawerOpen;
  self.drawerTable.alpha = _isDrawerOpen ? 1 : 0;
  // Note: I intentionally didn't use M_PI because if I did so the animation would be a 360 rotation
  // and not the desired reversible 180.
  _topBar.drawerButton.imageView.transform =
      CGAffineTransformRotate(_topBar.drawerButton.imageView.transform,
                              _isDrawerOpen ? 3.14 : -3.14);

  [self setNeedsLayout];
}

@end
