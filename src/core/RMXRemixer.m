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

#import "RMXRemixer.h"

#import "RMXFirebaseStorageController.h"
#import "RMXLocalStorageController.h"
#import "RMXVariable.h"
#import "UI/RMXOverlayViewController.h"
#import "UI/RMXOverlayWindow.h"

#if TARGET_OS_SIMULATOR
#define SWIPE_GESTURE_REQUIRED_TOUCHES 2
#else
#define SWIPE_GESTURE_REQUIRED_TOUCHES 3
#endif

typedef NS_ENUM(NSInteger, RMXStorageType) {
  RMXStorageTypeLocal = 0,
  RMXStorageTypeCloud = 1
};

@interface RMXRemixer () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMutableDictionary *variables;
@property(nonatomic, assign) RMXStorageType storageType;
@property(nonatomic, strong) id<RMXStorageController> storage;
@property(nonatomic, strong) RMXOverlayViewController *overlayController;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeUpGesture;
@property(nonatomic, strong) RMXOverlayWindow *overlayWindow;
@end

@implementation RMXRemixer

- (instancetype)init {
  self = [super init];
  if (self) {
    _variables = [NSMutableDictionary dictionary];
  }
  return self;
}

+ (instancetype)sharedInstance {
  static id sharedInstance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[self alloc] init];
  });
  return sharedInstance;
}

+ (void)startInLocalMode {
  RMXRemixer *instance = [self sharedInstance];
  instance.storageType = RMXStorageTypeLocal;
  [self start];
}

+ (void)startInCloudMode {
  RMXRemixer *instance = [self sharedInstance];
  instance.storageType = RMXStorageTypeCloud;
  [self start];
}

+ (void)start {
  UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
  if (!keyWindow) {
    // Get window if using storyboard.
    keyWindow = [[[UIApplication sharedApplication] delegate] window];
  }

  RMXRemixer *instance = [self sharedInstance];
  instance.swipeUpGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:[self sharedInstance]
                                                                      action:@selector(didSwipe:)];
  instance.swipeUpGesture.direction = UISwipeGestureRecognizerDirectionUp;
  instance.swipeUpGesture.numberOfTouchesRequired = SWIPE_GESTURE_REQUIRED_TOUCHES;
  instance.swipeUpGesture.delegate = [self sharedInstance];
  [keyWindow addGestureRecognizer:instance.swipeUpGesture];

  instance.overlayWindow = [[RMXOverlayWindow alloc] initWithFrame:keyWindow.frame];
  instance.overlayController = [[RMXOverlayViewController alloc] init];
  instance.overlayWindow.rootViewController = instance.overlayController;
  
  if (instance.storageType == RMXStorageTypeLocal) {
    instance.storage = [[RMXLocalStorageController alloc] init];
  } else {
    instance.storage = [[RMXFirebaseStorageController alloc] init];
  }
  [instance.storage setup];
  [instance.storage startObservingUpdates];
}

+ (void)stop {
  RMXRemixer *instance = [self sharedInstance];
  [instance.storage stopObservingUpdates];
  [instance.storage shutDown];
}

+ (NSString *)sessionId {
  // Store unique session id if doesn't exist.
  NSString *sessionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"sessionId"];
  if (!sessionId) {
    sessionId = [[[NSUUID UUID] UUIDString] substringToIndex:8];
    [[NSUserDefaults standardUserDefaults] setObject:sessionId forKey:@"sessionId"];
  }
  return sessionId;
}

+ (RMXOverlayWindow *)overlayWindow {
  return [[self sharedInstance] overlayWindow];
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
  _overlayWindow.hidden = NO;
  [_overlayController showPanelAnimated:YES];
}

#pragma mark - Email

+ (void)sendEmailInvite {
  // Genrates a mailto: URL string.
  NSString *sessionId = [self sessionId];
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

#pragma mark - Variables

+ (nullable RMXVariable *)variableForKey:(NSString *)key {
  return [[[self sharedInstance] variables] objectForKey:key];
}

+ (RMXVariable *)addVariable:(RMXVariable *)variable {
  RMXVariable *existingVariable = [self variableForKey:variable.key];
  if (!existingVariable) {
    [[[self sharedInstance] variables] setObject:variable forKey:variable.key];
    RMXVariable *storedVariable = [[[self sharedInstance] storage] variableForKey:variable.key];
    if (storedVariable) {
      [self updateVariable:variable usingStoredVariable:storedVariable];
    } else {
      [variable executeUpdateBlocks];
    }
  } else {
    [existingVariable addAndExecuteUpdateBlock:variable.updateBlocks.firstObject];
    variable = existingVariable;
  }

  // TODO(chuga): Figure out when and how to do the initial |saveRemix|.
  [[[self sharedInstance] overlayController] reloadData];
  return variable;
}

+ (void)removeVariable:(RMXVariable *)variable {
  [[[self sharedInstance] variables] removeObjectForKey:variable.key];
}

+ (void)removeVariableWithKey:(NSString *)key {
  RMXVariable *variable = [self variableForKey:key];
  [[self sharedInstance] removeVariable:variable];
}

+ (NSArray<RMXVariable *> *)allVariables {
  return [[[self sharedInstance] variables] allValues];
}

+ (void)removeAllVariables {
  [[[self sharedInstance] variables] removeAllObjects];
  [[[self sharedInstance] overlayController] reloadData];
}

+ (void)saveVariable:(RMXVariable *)variable {
  [[[self sharedInstance] storage] saveVariable:variable];
}

+ (void)updateVariable:(RMXVariable *)variable usingStoredVariable:(RMXVariable *)storedVariable {
  RMXRemixer *instance = [self sharedInstance];
  if (instance.storageType == RMXStorageTypeCloud) {
    [variable updateToStoredVariable:storedVariable];
  } else {
    [variable setSelectedValue:storedVariable.selectedValue];
  }
}

@end
