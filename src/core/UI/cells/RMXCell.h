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

#import "RMXOverlayResources.h"
#import "RMXVariable.h"

NS_ASSUME_NONNULL_BEGIN

@class RMXCell;

/** Minimal height for the cell. */
extern const CGFloat RMXCellHeightMinimal;

/** Larger height for the cell. */
extern const CGFloat RMXCellHeightLarge;

@protocol RMXCellDelegate <NSObject>

/**
 Called by the cell when it requires the overlay to go full screen.
 One example use case is when the keyboard appears.
 */
- (void)cellRequestedFullScreenOverlay:(RMXCell *)cell;

@end

/**
 The RMXCell class provides table view cell that should be subclassed for specific Variable
 model types.
 */
@interface RMXCell : UITableViewCell

/** A view that all subclasses should add their inner controls to as subviews. */
@property(nonatomic, strong) UIView *controlViewWrapper;

/** The Variable this cell is controlling. */
@property(nonatomic, weak) RMXVariable *variable;

/** The delegate for this cell. */
@property(nonatomic, weak) id<RMXCellDelegate> delegate;

/** The height of this cell. Subclasses should override. */
+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
