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

#import <UIKit/UIKit.h>

@protocol RMXShareLinkCellDelegate;
@protocol RMXShareSwitchCellDelegate;

static const CGFloat RMXOverlayTopBarClosedHeight = 60.0f;
static const CGFloat RMXOverlayDrawerAnimationDuration = 0.2f;

/** The view that contains the top bar and the sharing options drawer. */
@interface RMXOverlayTopBarView : UIView

/** The button that closes the overlay. */
@property(nonatomic, readonly) UIButton *closeButton;

/** The 'Remixer' label that goes next to the close button. */
@property(nonatomic, readonly) UILabel *titleLabel;

/** The arrow icon that toggles the drawer. */
@property(nonatomic, readonly) UIButton *drawerButton;

/** The table view with the sharing options and info. */
@property(nonatomic, readonly) UITableView *drawerTable;

/** The delegate for the cell that has the switch to turn sharing on or off. */
@property(nonatomic, weak) id<RMXShareSwitchCellDelegate> shareSwitchCellDelegate;

/** The delegate for the cell that has the URL of the remote controller. */
@property(nonatomic, weak) id<RMXShareLinkCellDelegate> shareLinkCellDelegate;

/** Call this to update the 'SHARING' label that goes next to the arrow icon. */
- (void)displaySharing:(BOOL)sharing;

@end
