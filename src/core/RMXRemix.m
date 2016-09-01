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

#import "RMXRemix.h"

#import "RMXApp.h"
#import "RMXRemixDelegate.h"

@interface RMXRemix ()
@property(nonatomic, strong) NSString *key;
@property(nonatomic, strong) id<RMXModel> _model;
@property(nonatomic, strong) NSMutableDictionary *remixes;
@property(nonatomic, strong) NSMutableSet *updateBlocks;
@end

@implementation RMXRemix

- (instancetype)init {
  self = [super init];
  if (self) {
    _remixes = [NSMutableDictionary dictionary];
    _updateBlocks = [NSMutableSet set];
    _appDelegate = [RMXApp sharedInstance];
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

- (id<RMXModel>)model {
  return self._model;
}

#pragma mark - Adding

+ (instancetype)addRemixWithKey:(NSString *)key
                   usingControl:(id<RMXModel>)control
                  selectedValue:(NSNumber *)selectedValue
                    updateBlock:(RMXUpdateBlock)updateBlock {
  // Get existing Remix at key, or create a new one.
  RMXRemix *remix = [self remixForKey:key];
  if (!remix) {
    remix = [[RMXRemix alloc] init];
    remix.key = key;
    control.defaultValue = selectedValue;
    [[[self sharedInstance] remixes] setObject:remix forKey:key];
  }

  remix._model = control;

  // Load saved value.
  id savedValue = [remix savedValueForKey:key];
  if (savedValue != nil) {
    remix.selectedValue = savedValue;
  } else {
    remix.selectedValue = selectedValue;
  }

  [remix.updateBlocks addObject:updateBlock];
  updateBlock(remix, remix.selectedValue);

  // Notify delegate.
  if ([remix.appDelegate respondsToSelector:@selector(didAddRemix:)]) {
    [remix.appDelegate didAddRemix:remix];
  }

  return remix;
}

#pragma mark - Updating

+ (void)updateSelectedValue:(NSNumber *)selectedValue
                   forRemix:(RMXRemix *)remix
                 shouldSync:(BOOL)shouldSync {
  if (!remix) {
    return;
  }

  remix.isSynced = !shouldSync;

  // Notify cell delegate remix:willSelectValue:
  if ([remix.cellDelegate respondsToSelector:@selector(remix:willSelectValue:)]) {
    [remix.cellDelegate remix:remix willSelectValue:selectedValue];
  }

  // Notify app delegate remix:willSelectValue:
  if ([remix.appDelegate respondsToSelector:@selector(remix:willSelectValue:)]) {
    [remix.appDelegate remix:remix willSelectValue:selectedValue];
  }

  // Update selected value.
  [remix setSelectedValue:selectedValue];

  // Notify cell delegate remix:didSelectValue:
  if ([remix.cellDelegate respondsToSelector:@selector(remix:didSelectValue:)]) {
    [remix.cellDelegate remix:remix didSelectValue:selectedValue];
  }

  // Notify app delegate remix:didSelectValue:
  if ([remix.appDelegate respondsToSelector:@selector(remix:didSelectValue:)]) {
    [remix.appDelegate remix:remix didSelectValue:selectedValue];
  }

  // Update blocks.
  for (RMXUpdateBlock updateBlock in remix.updateBlocks) {
    updateBlock(remix, selectedValue);
  }

  // Commit changes;
  if (!remix.model.delaysCommit) {
    [remix commit];
  }
}

+ (void)sendNotificationWithKey:(NSString *)key {
  // Update blocks.
  RMXRemix *remix = [self remixForKey:key];
  for (RMXUpdateBlock updateBlock in remix.updateBlocks) {
    updateBlock(remix, nil);
  }
}

+ (void)restoreDefaults {
  for (RMXRemix *remix in [self allRemixes]) {
    [self updateSelectedValue:remix.model.defaultValue forRemix:remix shouldSync:YES];
  }
}

#pragma mark - Removing

+ (void)removeRemixWithKey:(NSString *)key {
  RMXRemix *remix = [self remixForKey:key];
  [remix.updateBlocks removeAllObjects];
  [[[self sharedInstance] remixes] removeObjectForKey:key];

  // Notify delegate.
  if ([remix.appDelegate respondsToSelector:@selector(didRemoveRemixWithKey:)]) {
    [remix.appDelegate didRemoveRemixWithKey:remix.key];
  }
}

+ (void)removeAllRemixes {
  for (RMXRemix *remix in [self allRemixes]) {
    [remix.updateBlocks removeAllObjects];
  }
  [[[self sharedInstance] remixes] removeAllObjects];

  // Notify delegate.
  if ([[RMXApp sharedInstance] respondsToSelector:@selector(didRemoveAllRemixes)]) {
    [[RMXApp sharedInstance] didRemoveAllRemixes];
  }
}

#pragma mark - Querying

+ (NSArray<RMXRemix *> *)allRemixes {
  return [[[self sharedInstance] remixes] allValues];
}

+ (RMXRemix *)remixForKey:(NSString *)key {
  return [[[self sharedInstance] remixes] objectForKey:key];
}

#pragma mark - Storage

- (id)savedValueForKey:(NSString *)key {
  return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)commit {
  [[NSUserDefaults standardUserDefaults] setObject:self.selectedValue forKey:self.key];
}

#pragma mark - Syncing

- (void)sync {
  if ([[RMXApp sharedInstance] respondsToSelector:@selector(syncRemix:)]) {
    [[RMXApp sharedInstance] syncRemix:self];
  }
}

@end
