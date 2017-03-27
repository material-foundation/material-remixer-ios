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
#import "RMXCellColorInput.h"
#import "RMXCellColorList.h"
#import "RMXCellSegmented.h"
#import "RMXCellSlider.h"
#import "RMXCellStepper.h"
#import "RMXCellSwitch.h"
#import "RMXCellTextInput.h"
#import "RMXCellTextList.h"
#import "RMXOverlayTopBarView.h"
#import "RMXOverlayView.h"
#import "RMXOverlayWindow.h"
#import "RMXRemixer.h"
#import "RMXShareLinkCell.h"
#import "RMXShareSwitchCell.h"

static CGFloat kPanelHeightThreshold = 500.0f;
static CGFloat kAnimationDuration = 0.3f;
static CGFloat kSpringDamping = 0.8f;
static CGFloat kInitialSpeed = 0.4f;

@interface RMXOverlayViewController () <UITableViewDataSource,
                                        UITableViewDelegate,
                                        UIGestureRecognizerDelegate,
                                        RMXCellDelegate,
                                        RMXShareLinkCellDelegate,
                                        RMXShareSwitchCellDelegate>
@property(nonatomic, strong) RMXOverlayView *view;
@end

@implementation RMXOverlayViewController {
  UIPanGestureRecognizer *_panGestureRecognizer;
  CGFloat _gestureInitialDelta;
}

@dynamic view;

- (void)loadView {
  self.view =
      [[RMXOverlayView alloc] initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
  [self.view hidePanel];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.topBar.shareLinkCellDelegate = self;
  self.view.topBar.shareSwitchCellDelegate = self;

  self.view.tableView.dataSource = self;
  self.view.tableView.delegate = self;
  self.view.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
  [self.view.tableView registerClass:[RMXCellButton class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellButton class])];
  [self.view.tableView registerClass:[RMXCellColorList class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellColorList class])];
  [self.view.tableView registerClass:[RMXCellColorInput class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellColorInput class])];
  [self.view.tableView registerClass:[RMXCellSegmented class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSegmented class])];
  [self.view.tableView registerClass:[RMXCellSlider class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSlider class])];
  [self.view.tableView registerClass:[RMXCellStepper class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellStepper class])];
  [self.view.tableView registerClass:[RMXCellSwitch class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellSwitch class])];
  [self.view.tableView registerClass:[RMXCellTextList class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellTextList class])];
  [self.view.tableView registerClass:[RMXCellTextInput class]
              forCellReuseIdentifier:NSStringFromClass([RMXCellTextInput class])];

  [self.view.closeButton addTarget:self
                            action:@selector(dismissOverlay:)
                  forControlEvents:UIControlEventTouchUpInside];
  [self.view.drawerButton addTarget:self
                             action:@selector(toggleDrawer:)
                   forControlEvents:UIControlEventTouchUpInside];
  _panGestureRecognizer =
      [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
  _panGestureRecognizer.delegate = self;
  [self.view.topBar addGestureRecognizer:_panGestureRecognizer];

  if (![RMXRemixer remoteControllerURL]) {
    self.view.drawerButton.hidden = YES;
    self.view.drawerTable.hidden = YES;
  } else {
    [self.view.topBar displaySharing:[RMXRemixer isSharing]];
  }
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
  RMXCell *cellForVariable;
  RMXVariable *variable = notification.object;
  if (variable) {
    NSUInteger index =
        [[[[RMXRemixer allVariables] objectEnumerator] allObjects] indexOfObject:variable];
    NSIndexPath *cellIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    cellForVariable = [self.view.tableView cellForRowAtIndexPath:cellIndexPath];
  }
  if (cellForVariable) {
    [cellForVariable setVariable:variable];
  } else {
    // If we couldn't find the cell we revert back to reloading the data and the table view.
    [self reloadData];
  }
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
    _gestureInitialDelta = [recognizer locationInView:self.view.topBar].y;
  } else if (recognizer.state == UIGestureRecognizerStateEnded) {
    if (self.view.panelHeight <= 2 * RMXOverlayTopBarClosedHeight) {
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
                              RMXOverlayTopBarClosedHeight);
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
  [self dismissOverlayWithCompletion:nil];
}

- (void)dismissOverlayWithCompletion:(void (^)(BOOL finished))completion {
  [self.view endEditing:YES];
  [UIView animateWithDuration:kAnimationDuration
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
  [self.view.tableView reloadData];
}

- (void)toggleDrawer:(id)sender {
  [UIView animateWithDuration:RMXOverlayDrawerAnimationDuration
                        delay:0
                      options:UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     [self.view toggleDrawer];
                     [self.view layoutSubviews];
                   }
                   completion:^(BOOL finished){
                   }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // We use the objectEnumerator to leave out any variables that have been already dealloc'ed.
  return [[[[RMXRemixer allVariables] objectEnumerator] allObjects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXVariable *variable = [[[RMXRemixer allVariables] objectEnumerator] allObjects][indexPath.row];
  NSString *identifier = [self cellIdentifierForVariable:variable];
  RMXCell *cell = (RMXCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  cell.variable = variable;
  cell.delegate = self;
  return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXVariable *variable = [[[RMXRemixer allVariables] objectEnumerator] allObjects][indexPath.row];
  return [[self cellClassForVariable:variable] cellHeight];
}

#pragma mark - RMXCellDelegate

- (void)cellRequestedFullScreenOverlay:(RMXCell *)cell {
  [self maximizePanel];
}

#pragma mark - RMXShareLinkCellDelegate

- (void)shareLinkButtonWasTapped:(UIButton *)linkButton {
  UIActivityViewController *activityViewController =
      [[UIActivityViewController alloc] initWithActivityItems:@[[RMXRemixer remoteControllerURL]]
                                        applicationActivities:nil];
  [[[RMXRemixer overlayWindow] rootViewController] presentViewController:activityViewController
                                                                animated:YES
                                                              completion:nil];
}

#pragma mark - RMXShareSwitchCellDelegate

- (void)switchControlWasUpdated:(UISwitch *)switchControl {
  [RMXRemixer setSharing:switchControl.isOn];
  [self.view.topBar displaySharing:switchControl.isOn];
}

#pragma mark - Private

- (Class)cellClassForVariable:(RMXVariable *)variable {
  // TODO(chuga): This is probably not very fast. We should revisit it.
  if ([variable.controlType isEqualToString:RMXControlTypeButton]) {
    return [RMXCellButton class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeColorList]) {
    return [RMXCellColorList class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeColorInput]) {
    return [RMXCellColorInput class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeSegmented]) {
    return [RMXCellSegmented class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeSlider]) {
    return [RMXCellSlider class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeStepper]) {
    return [RMXCellStepper class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeSwitch]) {
    return [RMXCellSwitch class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeTextList]) {
    return [RMXCellTextList class];
  } else if ([variable.controlType isEqualToString:RMXControlTypeTextInput]) {
    return [RMXCellTextInput class];
  }
  return nil;
}

- (NSString *)cellIdentifierForVariable:(RMXVariable *)variable {
  return NSStringFromClass([self cellClassForVariable:variable]);
}

@end
