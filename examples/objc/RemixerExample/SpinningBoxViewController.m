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

#import "SpinningBoxViewController.h"

#import "Remixer.h"

@implementation SpinningBoxViewController {
  UIView *_box1;
  UIView *_box2;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor whiteColor];

  _box1 = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 80, 80)];
  _box1.backgroundColor = [UIColor redColor];
  [self.view addSubview:_box1];

  _box2 = [[UIView alloc] initWithFrame:CGRectMake(200, 150, 80, 80)];
  _box2.backgroundColor = [UIColor blueColor];
  [self.view addSubview:_box2];

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  animation.toValue = [NSNumber numberWithFloat:(M_PI * 2)];
  animation.repeatCount = HUGE_VALF;

  [RMXRangeRemix
      addRangeRemixWithKey:@"box1Animation"
              defaultValue:1
                  minValue:0.5
                  maxValue:2.0
                 increment:0
               updateBlock:^(RMXRemix *_Nonnull remix, CGFloat selectedValue) {
                 // Set box 1 animation.
                 CALayer *presentationLayer = _box1.layer.presentationLayer;
                 CGFloat angle =
                     [[presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
                 animation.fromValue = [NSNumber numberWithFloat:angle];
                 animation.toValue = [NSNumber numberWithFloat:angle + M_PI * 2.0];
                 animation.duration = MAX(2.0 - selectedValue, 0.1);
                 [_box1.layer addAnimation:animation forKey:@"spinning"];

                 // Set box2 animation to be twice as fast.
                 presentationLayer = _box2.layer.presentationLayer;
                 angle = [[presentationLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
                 animation.fromValue = [NSNumber numberWithFloat:angle];
                 animation.toValue = [NSNumber numberWithFloat:angle + M_PI * 2.0];
                 animation.duration = MAX(2.0 - (selectedValue * 2), 0.1);
                 [_box2.layer addAnimation:animation forKey:@"spinning"];
               }];

  [RMXBooleanRemix addBooleanRemixWithKey:@"slowAnimations"
                             defaultValue:NO
                              updateBlock:^(RMXRemix *remix, BOOL selectedValue) {
                                CALayer *layer = self.view.layer;
                                layer.timeOffset =
                                    [layer convertTime:CACurrentMediaTime() fromLayer:nil];
                                layer.beginTime = CACurrentMediaTime();
                                layer.speed = selectedValue ? 0.2 : 1;
                              }];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [RMXRemixer removeAllRemixes];
}

@end
