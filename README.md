![remixer](https://cdn.rawgit.com/material-foundation/material-remixer/master/docs/assets/lockup_remixer_icon_horizontal_dark_small.svg)

[![Build Status](https://travis-ci.org/material-foundation/material-remixer-ios.svg?branch=develop)](https://travis-ci.org/material-foundation/material-remixer-ios)
[![codecov](https://codecov.io/gh/material-foundation/material-remixer-ios/branch/develop/graph/badge.svg)](https://codecov.io/gh/material-foundation/material-remixer-ios)
[![CocoaPods](https://img.shields.io/cocoapods/v/Remixer.svg)]()

Remixer is a framework to iterate quickly on UI changes by allowing you to adjust UI variables without needing to rebuild (or even restart) your app. You can adjust Numbers, Colors, Booleans, and Strings. To see it in action check out the [example app](https://github.com/material-foundation/material-remixer-ios/tree/develop/examples/objc).

If you are interested in using Remixer in another platform, you may want to check out the [Android](https://github.com/material-foundation/material-remixer-android) and [Javascript](https://github.com/material-foundation/material-remixer-js) repos. With any of the three platforms you can use the [Remote Controller](https://github.com/material-foundation/material-remixer-remote-web).

- - -

## Installation

### Requirements

- Xcode 7.0 or higher.
- iOS 8.0 or higher.

## Quickstart

### 1. Install CocoaPods

[CocoaPods](https://cocoapods.org/) is the easiest way to get started. If you're new to CocoaPods,
check out their [getting started documentation](https://guides.cocoapods.org/using/getting-started.html).

To install CocoaPods, run the following commands:

~~~ bash
sudo gem install cocoapods
~~~

### 2. Create Podfile

Once you've created an iOS application in Xcode you can start using Remixer for iOS.

To initialize CocoaPods in your project, run the following commands:

~~~ bash
cd your-project-directory
pod init
~~~

### 3. Edit Podfile

Once you've initialized CocoaPods, add the [Remixer iOS Pod](https://cocoapods.org/pods/Remixer)
to your target in your Podfile:

~~~ ruby
target "MyApp" do
  ...
  pod 'Remixer'
end
~~~

Then run the command:

~~~ bash
pod install
open your-project.xcworkspace
~~~

Now you're ready to get started in Xcode.

### 4. Add variables

Now you’re ready to add Remixer to your app! Begin by importing the Remixer header and forward these three AppDelegate's events:

~~~ objc
#import "Remixer.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Create the window
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Let Remixer know that the app finished launching.
  [RMXRemixer applicationDidFinishLaunching];

  // Create the root view controller and set it in the window
  self.window.rootViewController = [[UIViewController alloc] init];
  [self.window makeKeyAndVisible];

  return YES;
}

// Make sure you propagate these two events if you're using the Remote Controllers / Firebase option
- (void)applicationDidBecomeActive:(UIApplication *)application {
  [RMXRemixer applicationDidBecomeActive];
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [RMXRemixer applicationWillResignActive];
}

@end
~~~

Now you can add Remixer variables in your view controller classes as follows:

~~~ objc
#import "Remixer.h"

@implementation ExampleViewController {
  UIView *_box;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _box = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
  _box.backgroundColor = [UIColor redColor];
  [self.view addSubview:_box];

  // Add a color variable to control the background color.
  // Note: You can set possibleValues to limit it to certain colors.
  [RMXColorVariable
      colorVariableWithKey:@"boxBgColor"
              defaultValue:_box.backgroundColor
            possibleValues:nil
               updateBlock:^(RMXColorVariable *_Nonnull variable, UIColor *selectedValue) {
                 _box.backgroundColor = selectedValue;
               }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  // This prevents the variables from showing up in the overlay once you leave
  // this view controller.
  [RMXRemixer removeAllVariables];
}
~~~

### 5. Refine their values

Run the app and swipe up with 3 fingers (or 2 if you're using the simulator). This will trigger the Remixer overlay. From here you can see the variables your app is using, and refine their values.

![screenshot](demo_screenshot.png)

## Is material-foundation affiliated with Google?

Yes, the [material-foundation](https://github.com/material-foundation) organization is one of Google's new homes for tools and frameworks related to our [Material Design](https://material.io) system. Please check out our blog post [Design is Never Done](https://design.google.com/articles/design-is-never-done/) for more information regarding Material Design and how Remixer integrates with the system.

## Contributing

We gladly welcome contributions! If you have found a bug, have questions, or wish to contribute, please follow our [Contributing Guidelines](https://github.com/material-foundation/material-remixer-ios/blob/develop/CONTRIBUTING.md).

## License

© Google, 2016. Licensed under an [Apache-2](https://github.com/material-foundation/material-remixer-ios/blob/develop/LICENSE) license.
