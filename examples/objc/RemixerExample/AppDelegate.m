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

#import "AppDelegate.h"

#import "TransactionsListViewController.h"
#import "Remixer.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  TransactionsListViewController *main = [[TransactionsListViewController alloc] init];
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:main];
  [nav.navigationBar setBackgroundImage:[UIImage new]
                          forBarMetrics:UIBarMetricsDefault];
  nav.navigationBar.shadowImage = [UIImage new];
  nav.navigationBar.translucent = YES;
  nav.navigationBar.titleTextAttributes = @{
    NSFontAttributeName: [UIFont systemFontOfSize:20.0],
    NSForegroundColorAttributeName: [UIColor whiteColor]
  };


  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.rootViewController = nav;
  [self.window makeKeyAndVisible];

  [RMXRemixer applicationDidFinishLaunching];

  return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  [RMXRemixer applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [RMXRemixer applicationWillResignActive];
}

@end
