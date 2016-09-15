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

#import "RMXApp.h"

#import "RMXRemix.h"
#import "UI/RMXOverlayController.h"

#if TARGET_OS_SIMULATOR
#define SWIPE_GESTURE_REQUIRED_TOUCHES 2
#else
#define SWIPE_GESTURE_REQUIRED_TOUCHES 3
#endif

@interface RMXApp () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) RMXOverlayController *overlayController;
@end

@implementation RMXApp {
  UISwipeGestureRecognizer *_swipeUpGesture;
}

+ (instancetype)sharedInstance {
  static id sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

- (void)start {
  UIWindow *window = [[UIApplication sharedApplication] keyWindow];
  _swipeUpGesture =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
  _swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
  _swipeUpGesture.numberOfTouchesRequired = SWIPE_GESTURE_REQUIRED_TOUCHES;
  _swipeUpGesture.delegate = self;
  [window addGestureRecognizer:_swipeUpGesture];
}

- (NSString *)sessionId {
  // Store unique session id if doesn't exist.
  NSString *_sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
  if (!_sessionId) {
    _sessionId = [[[NSUUID UUID] UUIDString] substringToIndex:8];
    [[NSUserDefaults standardUserDefaults] setObject:_sessionId forKey:@"sessionId"];
  }
  return _sessionId;
}

#pragma mark - Swipe gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
  if ((gestureRecognizer == _swipeUpGesture) &&
      (gestureRecognizer.numberOfTouches == SWIPE_GESTURE_REQUIRED_TOUCHES)) {
    otherGestureRecognizer.enabled = NO;
    otherGestureRecognizer.enabled = YES;
    return YES;
  }
  return NO;
}

- (void)didSwipe:(UISwipeGestureRecognizer *)recognizer {
  UIViewController *root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
  if (![root.presentedViewController isKindOfClass:[RMXOverlayController class]]) {
    if (!_overlayController) {
      _overlayController = [[RMXOverlayController alloc] init];
      _overlayController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
      _overlayController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    [root presentViewController:_overlayController animated:YES completion:nil];
  }
}

#pragma mark - Email

+ (void)sendEmailInvite {
  // Genrates a mailto: URL string.
  NSString *sessionId = [[self sharedInstance] sessionId];
  NSString *remixerURL =
      [NSString stringWithFormat:@"https://remix-4d1f9.firebaseapp.com/#/composer/%@", sessionId];
  NSString *subject = [NSString stringWithFormat:@"Invitation to Remixer session %@", sessionId];
  NSString *body = [NSString stringWithFormat:@"You have been invited to a Remixer session. \n\n"
                                              @"Follow this link to log in: <a href='%@'>%@</a>",
                                              remixerURL, sessionId];
  NSString *mailTo = [NSString stringWithFormat:@"mailto:?subject=%@&body=%@", subject, body];
  NSString *url = [mailTo stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

@end
