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

#import "RMXOverlayNavigationBar.h"

#import "RMXOverlayResources.h"

@implementation RMXOverlayNavigationBar

static CGFloat kButtonWidth = 110.0f;
static CGFloat kButtonHeight = 40.0f;
NSString *const kButtonTitleRemixer = @"Remixer";
NSString *const kButtonTitleNearby = @"NEARBY";

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.25;

    UINavigationItem *item = [[UINavigationItem alloc] init];
    [self pushNavigationItem:item animated:NO];

    _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_closeButton setFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
    [_closeButton setTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [_closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_closeButton setTitle:kButtonTitleRemixer forState:UIControlStateNormal];
    [_closeButton setImage:RMXResources(RMXIconClose) forState:UIControlStateNormal];
    [_closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];

    _remoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_remoteButton setFrame:CGRectMake(0, 0, kButtonWidth, kButtonHeight)];
    [_remoteButton setTintColor:
        [UIColor colorWithRed:0.1569 green:0.4118 blue:0.9922 alpha:0.8]]; // #2869FC
    [_remoteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [_remoteButton setTitleColor:
        [UIColor colorWithRed:0.1569 green:0.4118 blue:0.9922 alpha:0.8] // #2869FC
                     forState:UIControlStateNormal];
    [_remoteButton setTitle:kButtonTitleNearby forState:UIControlStateNormal];
    [_remoteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [_remoteButton setImage:RMXResources(RMXIconWifi) forState:UIControlStateNormal];
    // Flip image to right.
    _remoteButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _remoteButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    _remoteButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);

    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_closeButton];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_remoteButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
  _closeButton.center = CGPointMake(_closeButton.center.x, self.center.y);
  _remoteButton.center = CGPointMake(_remoteButton.center.x, self.center.y);
}

@end
