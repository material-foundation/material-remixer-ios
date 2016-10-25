![remixer](https://github.com/material-foundation/material-remixer/raw/master/docs/assets/lockup_remixer_icon_horizontal_dark.png)

Remixer helps teams use and refine design specs by providing an abstraction for these values that is accessible and configurable from both inside and outside the app itself. 

This SDK for iOS is currently in development.

New to Remixer? Visit our [main repo](https://github.com/material-foundation/material-remixer) to get a full description of what it is and how it works.
- - -

## Installation

### Requirements

- Xcode 7.0 or higher.
- iOS SDK version 8.0 or higher.

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

### 4. Usage

Now you’re ready to add Remixer to your app! Begin by importing the Remixer header and call the
shared start method in your AppDelegate class.

Note that we currently support only RMXStorageModeLocal as RMXStorageModeCloud is still in development.

~~~ objc
#import "Remixer.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
  // Create the window
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // Start Remixer
  [RMXRemixer startInMode:RMXStorageModeLocal];
  
  // Create the root view controller and set it in the window
  self.window.rootViewController = [[UIViewController alloc] init];
  [self.window makeKeyAndVisible];

  return YES;
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
               updateBlock:^(RMXColorVariable *_Nonnull variable, UIColor *selectedValue) {
                 _box.backgroundColor = selectedValue;
               }];

@end
~~~

## Example App

- [Objective-C example app](examples/objc)

## Other Repositories

Other platform specific libraries and tools can be found in the following GitHub repos:

- [Android](https://github.com/material-foundation/material-remixer-android) - Remixer for Android.
- [Web](https://github.com/material-foundation/material-remixer-web) - Remixer for Web.
- Dashboard - Remixer web dashboard for all platforms (available soon).

