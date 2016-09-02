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

#import "RMXOverlayController.h"

#import "RMXApp.h"
#import "RMXCell.h"
#import "RMXOverlayNavigationBar.h"
#import "RMXOverlayResources.h"
#import "RMXRemix.h"

/** A mapping of cell class names to their repective RMXModel types. */
NSString *const kCellButton = @"RMXCellButton";
NSString *const kCellColorPicker = @"RMXCellColorPicker";
NSString *const kCellSegmented = @"RMXCellSegmented";
NSString *const kCellSlider = @"RMXCellSlider";
NSString *const kCellStepper = @"RMXCellStepper";
NSString *const kCellSwitch = @"RMXCellSwitch";
NSString *const kCellTextPicker = @"RMXCellTextPicker";

NSString *const kToolbarButtonTitleRestore = @"Restore Defaults";

static CGFloat kOptionsViewHeight = 400.0f;
static CGFloat kOptionsViewAnimationDuration = 0.3f;
static CGFloat kOptionsViewSpringDamping = 0.8f;
static CGFloat kOptionsViewSpringVelocity = 0.4f;
static CGFloat kNavbarHeight = 60.0f;
static CGFloat kToolbarHeight = 44.0f;

@interface RMXOverlayController () <UITableViewDataSource, UITableViewDelegate>
@end

@implementation RMXOverlayController {
  UIView *_optionsView;
  UITableView *_tableView;
  NSArray<RMXRemix *> *_content;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  CGSize boundsSize = self.view.bounds.size;

  // Grayed semi-opaque background.
  self.view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];

  // Add tap dismissing gesture.
  UITapGestureRecognizer *tapGesture =
      [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay:)];
  [self.view addGestureRecognizer:tapGesture];

  // Add swipe down dismissing gesture.
  UISwipeGestureRecognizer *swipeDownGesture =
      [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissOverlay:)];
  swipeDownGesture.direction = UISwipeGestureRecognizerDirectionDown;
  [self.view addGestureRecognizer:swipeDownGesture];

  // Add animated options view.
  _optionsView = [[UIView alloc] initWithFrame:CGRectMake(0, boundsSize.height - kOptionsViewHeight,
                                                          boundsSize.width, kOptionsViewHeight)];
  _optionsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  [self.view addSubview:_optionsView];

  CGRect tableFrame =
      CGRectMake(0, kNavbarHeight, boundsSize.width, kOptionsViewHeight - kNavbarHeight);
  _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
  _tableView.dataSource = self;
  _tableView.delegate = self;
  _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _tableView.contentInset = UIEdgeInsetsMake(-36, 0, kToolbarHeight, 0);
  _tableView.allowsSelection = NO;
  [_optionsView addSubview:_tableView];

  // Top navigation bar.
  RMXOverlayNavigationBar *navigationBar = [[RMXOverlayNavigationBar alloc]
      initWithFrame:CGRectMake(0, 0, boundsSize.width, kNavbarHeight)];
  [_optionsView addSubview:navigationBar];
  UINavigationItem *item = navigationBar.topItem;
  [(UIButton *)item.leftBarButtonItem.customView addTarget:self
                                                    action:@selector(dismissOverlay:)
                                          forControlEvents:UIControlEventTouchUpInside];
  [(UIButton *)item.rightBarButtonItem.customView addTarget:self
                                                     action:@selector(sendEmailInvite:)
                                           forControlEvents:UIControlEventTouchUpInside];

  // Bottom toolbar.
  UIToolbar *toolbar =
      [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, boundsSize.width, kToolbarHeight)];
  toolbar.clipsToBounds = YES;
  toolbar.barTintColor = _tableView.backgroundColor;
  toolbar.items = @[
    [self barButtonSpacer],
    [self barButtonItemWithIcon:RMXIconRestore
                          title:kToolbarButtonTitleRestore
                       selector:@selector(restoreDefaults:)],
    [self barButtonSpacer],
  ];
  _tableView.tableFooterView = toolbar;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self presentOptionsView];
}

#pragma mark - Presentation

- (void)presentOptionsView {
  [self reloadData];
  _optionsView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds));
  [UIView animateWithDuration:kOptionsViewAnimationDuration
                        delay:0
       usingSpringWithDamping:kOptionsViewSpringDamping
        initialSpringVelocity:kOptionsViewSpringVelocity
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     _optionsView.transform = CGAffineTransformIdentity;
                   }
                   completion:nil];
}

- (void)dismissOverlay:(id)sender {
  [self dismissOptionsViewWithCompletion:^(BOOL finished) {
    [self dismissViewControllerAnimated:YES completion:nil];
  }];
}

- (void)dismissOptionsViewWithCompletion:(void (^)(BOOL finished))completion {
  [UIView animateWithDuration:kOptionsViewAnimationDuration
      animations:^{
        _optionsView.transform =
            CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.view.bounds));
      }
      completion:^(BOOL finished) {
        if (completion) {
          completion(YES);
        }
      }];
}

- (void)reloadData {
  _content = [RMXRemix allRemixes];
  [_tableView reloadData];
}

- (void)sendEmailInvite:(id)sender {
  [RMXApp sendEmailInvite];
}

- (NSString *)cellClassWithModelType:(RMXModelType)modelType {
  if (modelType == kRMXModelTypeButton) {
    return kCellButton;
  } else if (modelType == kRMXModelTypeColorPicker) {
    return kCellColorPicker;
  } else if (modelType == kRMXModelTypeSegmented) {
    return kCellSegmented;
  } else if (modelType == kRMXModelTypeSlider) {
    return kCellSlider;
  } else if (modelType == kRMXModelTypeStepper) {
    return kCellStepper;
  } else if (modelType == kRMXModelTypeSwitch) {
    return kCellSwitch;
  } else if (modelType == kRMXModelTypeTextPicker) {
    return kCellTextPicker;
  }
  return nil;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXRemix *remix = _content[indexPath.row];
  NSString *identifier = [self cellClassWithModelType:remix.model.modelType];
  RMXCell *cell = (RMXCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  if (!cell) {
    Class cellClass = NSClassFromString(identifier);
    cell =
        [[cellClass alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
  }
  cell.remix = remix;
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  RMXRemix *remix = _content[indexPath.row];
  Class cellClass = NSClassFromString([self cellClassWithModelType:remix.model.modelType]);
  return [[cellClass class] cellHeight];
}

#pragma mark - UIToolbar

- (UIBarButtonItem *)barButtonItemWithIcon:(NSString *)iconName
                                     title:(NSString *)title
                                  selector:(SEL)sel {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [button setImage:RMXResources(iconName) forState:UIControlStateNormal];
  [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
  // Add spacing in title to separate from image.
  [button setTitle:[NSString stringWithFormat:@"  %@", title] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
  [button setTintColor:[UIColor darkGrayColor]];
  [button sizeToFit];
  [button addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
  return [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (UIBarButtonItem *)barButtonSpacer {
  return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                       target:nil
                                                       action:nil];
}

- (void)restoreDefaults:(id)sender {
  [RMXRemix restoreDefaults];
}

@end
