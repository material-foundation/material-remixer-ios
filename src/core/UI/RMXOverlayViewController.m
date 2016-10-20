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

#import "RMXOverlayViewController.h"

#import "RMXCellButton.h"
#import "RMXCellColorList.h"
#import "RMXCellSegmented.h"
#import "RMXCellSlider.h"
#import "RMXCellStepper.h"
#import "RMXCellSwitch.h"
#import "RMXCellTextInput.h"
#import "RMXCellTextPicker.h"
#import "RMXOverlayNavigationBar.h"
#import "RMXOverlayView.h"
#import "RMXRemixer.h"

static CGFloat kPanelHeightThreshold = 500.0f;
static CGFloat kAnimationDuration = 0.3f;
static CGFloat kSpringDamping = 0.8f;
static CGFloat kInitialSpeed = 0.4f;

@interface RMXOverlayViewController () <UITableViewDataSource,
                                        UITableViewDelegate,
                                        UIGestureRecognizerDelegate,
                                        RMXOverlayViewDelegate>
@property(nonatomic, strong) RMXOverlayView *view;
@end

@implementation RMXOverlayViewController {
  NSArray<RMXVariable *> *_content;
  UIPanGestureRecognizer *_panGestureRecognizer;
  CGFloat _gestureInitialDelta;
}

@dynamic view;

- (void)loadView {
  self.view =
      [[RMXOverlayView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
  [self.view hidePanel];
  self.view.delegate = self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.tableView.dataSource = self;
  self.view.tableView.delegate = self;

  [self.view.tableView registerClass:[RMXCellButton class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellButton class])];
  [self.view.tableView registerClass:[RMXCellColorList class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellColorList class])];
  [self.view.tableView registerClass:[RMXCellSegmented class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSegmented class])];
  [self.view.tableView registerClass:[RMXCellSlider class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSlider class])];
  [self.view.tableView registerClass:[RMXCellStepper class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellStepper class])];
  [self.view.tableView registerClass:[RMXCellSwitch class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSwitch class])];
  [self.view.tableView registerClass:[RMXCellTextPicker class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellTextPicker class])];
  [self.view.tableView registerClass:[RMXCellTextInput class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellTextInput class])];

  UINavigationItem *item = self.view.navigationBar.topItem;
  [(UIButton *)item.leftBarButtonItem.customView addTarget:self
                                                    action:@selector(dismissOverlay:)
                                          forControlEvents:UIControlEventTouchUpInside];
  [(UIButton *)item.rightBarButtonItem.customView addTarget:self
                                                     action:@selector(sendEmailInvite:)
                                           forControlEvents:UIControlEventTouchUpInside];
  _panGestureRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
  _panGestureRecognizer.delegate = self;
  [self.view.navigationBar addGestureRecognizer:_panGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(variableUpdateNotification:)
                                               name:RMXVariableUpdateNotification
                                             object:nil];
  [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)variableUpdateNotification:(NSNotification *)notification {
  [self reloadData];
}

#pragma mark - Public

- (void)hidePanelAnimated:(BOOL)animated {
  [UIView animateWithDuration:animated ? kAnimationDuration : 0
      delay:0
      usingSpringWithDamping:kSpringDamping
      initialSpringVelocity:kInitialSpeed
      options:UIViewAnimationOptionCurveLinear
      animations:^{
        [self.view hidePanel];
        [self.view layoutSubviews];
      }
      completion:^(BOOL finished) {
        self.view.hidden = YES;
      }];
}

- (void)showPanelAnimated:(BOOL)animated {
  [self reloadData];
  [self.view hidePanel];
  [self.view layoutSubviews];
  self.view.hidden = NO;
  [UIView animateWithDuration:animated ? kAnimationDuration : 0
                        delay:0
       usingSpringWithDamping:kSpringDamping
        initialSpringVelocity:kInitialSpeed
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.view showAtDefaultHeight];
                     [self.view layoutSubviews];
                   }
                   completion:^(BOOL finished){
                   }];
}

#pragma mark - Presentation

- (void)didPan:(UIPanGestureRecognizer *)recognizer {
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    _gestureInitialDelta = [recognizer locationInView:self.view.navigationBar].y;
  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    if (self.view.panelHeight <= 2 * RMXOverlayNavbarHeight) {
      [recognizer velocityInView:self.view].y >= 0 ? [self minimizePanel] : [self maximizePanel];
    } else if ([recognizer velocityInView:self.view].y > kPanelHeightThreshold) {
      [self minimizePanel];
    } else if ([recognizer velocityInView:self.view].y < -kPanelHeightThreshold) {
      [self maximizePanel];
    } else if (self.view.panelContainerView.frame.origin.y < 0) {
      [self maximizePanel];
    }
    return;
  }
  self.view.panelHeight = MAX(CGRectGetHeight(self.view.frame) -
                                  [recognizer locationInView:self.view].y + _gestureInitialDelta,
                              RMXOverlayNavbarHeight);
  [self.view setNeedsLayout];
}

- (void)minimizePanel {
  [UIView animateWithDuration:kAnimationDuration
                        delay:0
       usingSpringWithDamping:kSpringDamping
        initialSpringVelocity:kInitialSpeed
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.view showMinimized];
                     [self.view layoutSubviews];
                   }
                   completion:^(BOOL finished){
                   }];
}

- (void)maximizePanel {
  [UIView animateWithDuration:kAnimationDuration
                        delay:0
       usingSpringWithDamping:kSpringDamping
        initialSpringVelocity:kInitialSpeed
                      options:UIViewAnimationOptionCurveLinear
                   animations:^{
                     [self.view showMaximized];
                     [self.view layoutSubviews];
                   }
                   completion:^(BOOL finished){
                   }];
}

- (void)dismissOverlay:(id)sender {
  [self dismissOptionsViewWithCompletion:nil];
}

- (void)dismissOptionsViewWithCompletion:(void (^)(BOOL finished))completion {
  [UIView animateWithDuration:0.2
      animations:^{
        [self.view hidePanel];
        [self.view layoutSubviews];
      }
      completion:^(BOOL finished) {
        self.view.hidden = YES;
        if (completion) {
          completion(finished);
        }
      }];
}

- (void)reloadData {
  _content = [RMXRemixer allVariables];
  [self.view.tableView reloadData];
}

- (void)sendEmailInvite:(id)sender {
  [RMXRemixer sendEmailInvite];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXVariable *variable = _content[indexPath.row];
  NSString *identifier = [self cellIdentifierForVariable:variable];
  RMXCell *cell = (RMXCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  cell.variable = variable;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXVariable *variable = _content[indexPath.row];
  return [[self cellClassForVariable:variable] cellHeight];
}

#pragma mark - <RMXOverlayViewDelegate>

- (void)touchStartedAtPoint:(CGPoint)point withEvent:(UIEvent *)event {
  // No-op.
}

- (BOOL)shouldCapturePointOutsidePanel:(CGPoint)point {
  return self.presentedViewController != nil;
}

#pragma mark - Private

- (Class)cellClassForVariable:(RMXVariable *)variable {
  if (variable.controlType == RMXControlTypeButton) {
    return [RMXCellButton class];
  } else if (variable.controlType == RMXControlTypeColorList) {
    return [RMXCellColorList class];
  } else if (variable.controlType == RMXControlTypeSegmented) {
    return [RMXCellSegmented class];
  } else if (variable.controlType == RMXControlTypeSlider) {
    return [RMXCellSlider class];
  } else if (variable.controlType == RMXControlTypeStepper) {
    return [RMXCellStepper class];
  } else if (variable.controlType == RMXControlTypeSwitch) {
    return [RMXCellSwitch class];
  } else if (variable.controlType == RMXControlTypeTextPicker) {
    return [RMXCellTextPicker class];
  } else if (variable.controlType == RMXControlTypeTextInput) {
    return [RMXCellTextInput class];
  }
  return nil;
}

- (NSString *)cellIdentifierForVariable:(RMXVariable *)variable {
  return NSStringFromClass([self cellClassForVariable:variable]);
}

@end
