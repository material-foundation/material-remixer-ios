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

#import "RMXLocalStorageController.h"
#import "RMXRemoteController.h"
#import "RMXVariable.h"
#import "UI/RMXOverlayViewController.h"
#import "UI/RMXOverlayWindow.h"

#ifdef REMIXER_CLOUD_FIREBASE
#import "RMXFirebaseRemoteController.h"
#endif

#if TARGET_OS_SIMULATOR
#define SWIPE_GESTURE_REQUIRED_TOUCHES 2
#else
#define SWIPE_GESTURE_REQUIRED_TOUCHES 3
#endif

@interface RMXRemixer () <UIGestureRecognizerDelegate>
@property(nonatomic, strong) NSMapTable *variables;
@property(nonatomic, strong) id<RMXStorageController> storage;
@property(nonatomic, strong) id<RMXRemoteController> remoteController;
@property(nonatomic, strong) RMXOverlayViewController *overlayController;
@property(nonatomic, strong) UISwipeGestureRecognizer *swipeUpGesture;
@property(nonatomic, strong) RMXOverlayWindow *overlayWindow;
@end

@implementation RMXRemixer

- (instancetype)init {
  self = [super init];
  if (self) {
    _variables = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
                                       valueOptions:NSMapTableWeakMemory];
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

+ (void)initialize {
  RMXRemixer *instance = [self sharedInstance];
  instance.storage = [[RMXLocalStorageController alloc] init];
#ifdef REMIXER_CLOUD_FIREBASE
  instance.remoteController = [[RMXFirebaseRemoteController alloc] init];
#endif
}

+ (void)attachToKeyWindow {
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
}

+ (void)applicationDidBecomeActive {
  if ([self isSharing]) {
    [[[self sharedInstance] remoteController] restartConnection];
  }
}

+ (void)applicationWillResignActive {
  if ([self isSharing]) {
    [[[self sharedInstance] remoteController] pauseConnection];
  }
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

+ (void)reloadControllers {
  [[[self sharedInstance] overlayController] reloadData];
  [[[self sharedInstance] remoteController] reloadData];
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

#pragma mark - Variables

+ (nullable RMXVariable *)variableForKey:(NSString *)key {
  return [[[self sharedInstance] variables] objectForKey:key];
}

+ (__kindof RMXVariable *)addVariable:(RMXVariable *)variable {
  RMXVariable *existingVariable = [self variableForKey:variable.key];
  if (!existingVariable) {
    [[[self sharedInstance] variables] setObject:variable forKey:variable.key];
    id storedValue = [[[self sharedInstance] storage] selectedValueForVariableKey:variable.key];
    if (storedValue) {
      [variable setSelectedValue:storedValue];
    } else {
      [variable executeUpdateBlocks];
    }
  } else {
    [existingVariable addAndExecuteUpdateBlock:variable.updateBlocks.firstObject];
    variable = existingVariable;
  }

  [[[self sharedInstance] remoteController] addVariable:variable];
  [[[self sharedInstance] overlayController] reloadData];
  return variable;
}

+ (void)removeVariable:(RMXVariable *)variable {
  [[[self sharedInstance] variables] removeObjectForKey:variable.key];
  [[[self sharedInstance] overlayController] reloadData];
  [[[self sharedInstance] remoteController] removeVariable:variable];
}

+ (void)removeVariableWithKey:(NSString *)key {
  RMXVariable *variable = [self variableForKey:key];
  [[self sharedInstance] removeVariable:variable];
}

+ (void)removeAllVariables {
  [[[self sharedInstance] variables] removeAllObjects];
  [[[self sharedInstance] overlayController] reloadData];
  [[[self sharedInstance] remoteController] removeAllVariables];
}

+ (NSMapTable *)allVariables {
  return [[self sharedInstance] variables];
}

+ (void)saveVariable:(RMXVariable *)variable {
  [[[self sharedInstance] storage] saveSelectedValueOfVariable:variable];
  [[[self sharedInstance] remoteController] updateVariable:variable];
}

+ (void)updateVariable:(RMXVariable *)variable fromRemoteControllerToValue:(id)value {
  // TODO(chuga): Improve this check for equality.
  if (![variable.selectedValue isEqual:value]) {
    [variable setSelectedValue:value];
    [[[self sharedInstance] storage] saveSelectedValueOfVariable:variable];
  }
}

#pragma mark - Remote controller

+ (nullable NSURL *)remoteControllerURL {
  return [[[self sharedInstance] remoteController] remoteControllerURL];
}

+ (BOOL)isSharing {
  return [[[self sharedInstance] remoteController] isSharing];
}

+ (void)setSharing:(BOOL)sharing {
  [[[self sharedInstance] remoteController] setSharing:sharing];
}

@end
