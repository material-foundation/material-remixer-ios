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

@class RMXOverlayTopBarView;

/** The view of the RMXOverlayViewController. It contains the overlay's panel. */
@interface RMXOverlayView : UIView

/** A view that acts as a container for all the subviews of the panel. */
@property(nonatomic, readonly) UIView *panelContainerView;

/** The top bar of the overlay. */
@property(nonatomic, readonly) RMXOverlayTopBarView *topBar;

/** The button that closes the overlay. */
@property(nonatomic, readonly) UIButton *closeButton;

/** The button that opens and closes the sharing drawer. */
@property(nonatomic, readonly) UIButton *drawerButton;

/** Whether the sharing drawer is open. */
@property(nonatomic, readonly) BOOL isDrawerOpen;

/** The table displayed when the sharing drawer is opened. */
@property(nonatomic, readonly) UITableView *drawerTable;

/** A table view that contains the Remixer controls for the current variables. */
@property(nonatomic, readonly) UITableView *tableView;

/**
 The current height of the panel.
 Setting this to a different value changes the size of the panel.
 */
@property(nonatomic, assign) CGFloat panelHeight;

/** Hides the panel completely. Not animated. */
- (void)hidePanel;

/** Shows the panel minimized (just the nav bar is visible). Not animated. */
- (void)showMinimized;

/** Shows the panel at full screen. Not animated. */
- (void)showMaximized;

/** Shows the panel at a pre-defined height. Not animated. */
- (void)showAtDefaultHeight;

/** Toggles the state of the sharing drawer (opened or closed). */
- (void)toggleDrawer;

@end
