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

@class RMXOverlayNavigationBar;

static const CGFloat RMXOverlayNavbarHeight = 60.0f;

@protocol RMXOverlayViewDelegate <NSObject>

@optional

/** Notifies the delegate when a touch was detected anywhere in this view. */
- (void)touchStartedAtPoint:(CGPoint)point withEvent:(UIEvent *)event;

/**
 Asks the delegate if this view should capture a touch event that happened at a point that is
 outside of the overlay panel.
 @return Whether to capture the touch event.
 */
- (BOOL)shouldCapturePointOutsidePanel:(CGPoint)point;

@end

/** The view of the RMXOverlayViewController. It contains the overlay's panel. */
@interface RMXOverlayView : UIView

/** A view that acts as a container for all the subviews of the panel. */
@property(nonatomic, readonly) UIView *panelContainerView;

/** A custom navigation bar for the overlay. */
@property(nonatomic, readonly) RMXOverlayNavigationBar *navigationBar;

/** A table view that contains the Remixer controls. */
@property(nonatomic, readonly) UITableView *tableView;

/** A toolbar that sits at the bottom of the table view. */
@property(nonatomic, readonly) UIToolbar *bottomToolbar;

/**
 The current height of the panel.
 Setting this to a different value changes the size of the panel.
 */
@property(nonatomic, assign) CGFloat panelHeight;

/** The view's delegate */
@property(nonatomic, weak) id<RMXOverlayViewDelegate> delegate;

/** Hides the panel completely. Not animated. */
- (void)hidePanel;

/** Shows the panel minimized (just the nav bar is visible). Not animated. */
- (void)showMinimized;

/** Shows the panel at full screen. Not animated. */
- (void)showMaximized;

/** Shows the panel at a pre-defined height. Not animated. */
- (void)showAtDefaultHeight;

@end
