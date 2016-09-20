//
//  RMXOverlayWindow.m
//  Pods
//
//  Created by Andres Ugarte on 8/24/16.
//
//

#import "RMXOverlayWindow.h"

@implementation RMXOverlayWindow {
  UIPanGestureRecognizer *_gestureRecognizer;
}

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
    pointInside = [self.rootViewController.presentedViewController.view pointInside:point withEvent:event];
  } else {
    pointInside = [self.rootViewController.view pointInside:point withEvent:event];
  }
  return pointInside;
}

@end
