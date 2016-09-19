//
//  RMXLocalStorageController.m
//  Pods
//
//  Created by Andres Ugarte on 9/15/16.
//
//

#import "RMXLocalStorageController.h"

#import "RMXRemix.h"

@implementation RMXLocalStorageController

- (id)remixForKey:(NSString *)key {
  [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

- (void)saveRemix:(RMXRemix *)remix {
  [[NSUserDefaults standardUserDefaults] setObject:remix.selectedValue forKey:remix.key];
}

@end
