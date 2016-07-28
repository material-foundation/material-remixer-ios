# Remixer

Remixer is a set of libraries and protocols to allow live adjustment of apps and prototypes during
the development process.

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
  # Until Remixer iOS is public:
  pod 'Remixer', :git => 'https://github.com/material-foundation/material-remixer-ios.git'

  # After Remixer iOS is public:
  # pod 'Remixer'
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

~~~ objc
#import "Remixer.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // Start Remixer.
  [[RMXApp sharedInstance] start];

  return YES;
}

@end
~~~

Now you can add Remixer components in your view controller classes as follows:

~~~ objc
#import "Remixer.h"

@implementation ExampleViewController {
  UIView *_box;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _box = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
  [self.view addSubview:_box];

  // Add color picker.
  NSArray *colorOptions = @[ [UIColor blueColor], [UIColor redColor], [UIColor greenColor] ];
  RMXControlColorPicker *colorPickerControl =
      [RMXControlColorPicker controlWithTitle:@"Color Picker" array:colorOptions selectedIndex:1];
  [RMXRemix addRemixWithKey:@"colorPicker"
               usingControl:colorPickerControl
                updateBlock:^(RMXControl *control) {

                  // Now set the box background color.
                  _box.backgroundColor = [(RMXControlColorPicker *)control selectedColor];
                }];
}

@end
~~~

### 5. Example Apps

- [Objective-C example app](examples/)


