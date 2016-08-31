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

NSString *const kButtonTitleRemixer = @"Remixer";
NSString *const kButtonTitleNearby = @"NEARBY";

static CGFloat kButtonWidth = 110.0f;

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new]
                                       forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    self.backgroundColor = [UIColor whiteColor];
    self.layer.shadowRadius = 5;
    self.layer.shadowOpacity = 0.25;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;

    UINavigationItem *item = [[UINavigationItem alloc] init];
    [self pushNavigationItem:item animated:NO];

    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, kButtonWidth, frame.size.height)];
    [closeButton setTintColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    [closeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeButton setTitle:kButtonTitleRemixer forState:UIControlStateNormal];
    [closeButton setImage:RMXResources(RMXIconClose) forState:UIControlStateNormal];
    [closeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];

    UIButton *remoteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [remoteButton setFrame:CGRectMake(0, 0, kButtonWidth, frame.size.height)];
    [remoteButton
        setTintColor:[UIColor colorWithRed:0.1569 green:0.4118 blue:0.9922 alpha:0.8]];  // #2869FC
    [remoteButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [remoteButton
        setTitleColor:[UIColor colorWithRed:0.1569 green:0.4118 blue:0.9922 alpha:0.8]  // #2869FC
             forState:UIControlStateNormal];
    [remoteButton setTitle:kButtonTitleNearby forState:UIControlStateNormal];
    [remoteButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [remoteButton setImage:RMXResources(RMXIconWifi) forState:UIControlStateNormal];
    // Flip image to right.
    remoteButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    remoteButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    remoteButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);

    item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:remoteButton];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  // Center buttons vertically.
  for (UIButton *button in self.subviews) {
    if ([button isKindOfClass:[UIButton class]]) {
      button.center = CGPointMake(button.center.x, self.center.y);
    }
  }
}

@end
