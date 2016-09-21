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

#import "RMXOverlayWindow.h"

@implementation RMXOverlayWindow

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
    self.windowLevel = UIWindowLevelStatusBar + 100.0;
  }
  return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
  BOOL pointInside = NO;
  if (self.rootViewController.presentedViewController) {
    UIView *presentedView = self.rootViewController.presentedViewController.view;
    CGPoint adjustedPoint = [presentedView convertPoint:point fromView:self];
    pointInside = [presentedView pointInside:adjustedPoint withEvent:event];
  } else {
    pointInside = [self.rootViewController.view pointInside:point withEvent:event];
  }
  return pointInside;
}

@end
