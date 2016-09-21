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

#import "RMXRemixer.h"

#import "RMXRemix.h"
#import "RMXLocalStorageController.h"

@interface RMXRemixer ()
@property(nonatomic, strong) NSMutableDictionary *remixes;
@property(nonatomic, strong) RMXLocalStorageController *storage;
@end

@implementation RMXRemixer

- (instancetype)init {
  self = [super init];
  if (self) {
    _remixes = [NSMutableDictionary dictionary];
    _storage = [[RMXLocalStorageController alloc] init];
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

+ (nullable RMXRemix *)remixForKey:(NSString *)key {
  return [[[self sharedInstance] remixes] objectForKey:key];
}

+ (void)addRemix:(RMXRemix *)remix {
  RMXRemix *existingRemix = [self remixForKey:remix.key];
  if (!existingRemix) {
    [[[self sharedInstance] remixes] setObject:remix forKey:remix.key];
    RMXRemix *storedRemix = [[[self sharedInstance] storage] remixForKey:remix.key];
    if (storedRemix) {
      [remix setSelectedValue:storedRemix.selectedValue fromOverlay:NO];
    } else {
      [remix executeUpdateBlocks];
    }
  } else {
    [existingRemix addAndExecuteUpdateBlock:remix.updateBlocks.firstObject];
    remix = existingRemix;
  }

  remix.delegate = [self sharedInstance];
}

+ (void)removeRemix:(RMXRemix *)remix {
  [[[self sharedInstance] remixes] removeObjectForKey:remix.key];
}

+ (void)removeRemixWithKey:(NSString *)key {
  RMXRemix *remix = [self remixForKey:key];
  [[self sharedInstance] removeRemix:remix];
}

+ (NSArray<RMXRemix *> *)allRemixes {
  return [[[self sharedInstance] remixes] allValues];
}

+ (void)removeAllRemixes {
  [[[self sharedInstance] remixes] removeAllObjects];
}

#pragma mark - RMXRemixDelegate

- (void)remix:(RMXRemix *)remix wasUpdatedFromOverlayToValue:(nonnull id)value {
  if (!remix.delaysCommits) {
    [_storage saveRemix:remix];
  }
}

@end
