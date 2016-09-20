//
//  RMXOverlayView.h
//  Pods
//
//  Created by Andres Ugarte on 9/20/16.
//
//

#import <UIKit/UIKit.h>

@class RMXOverlayNavigationBar;

static const CGFloat RMXOverlayNavbarHeight = 60.0f;

@protocol RMXOverlayViewDelegate <NSObject>

@optional
- (void)touchStartedAtPoint:(CGPoint)point withEvent:(UIEvent *)event;
- (BOOL)shouldCapturePointOutsidePanel:(CGPoint)point;

@end

@interface RMXOverlayView : UIView

@property(nonatomic, readonly) UIView *panelContainerView;
@property(nonatomic, readonly) RMXOverlayNavigationBar *navigationBar;
@property(nonatomic, readonly) UITableView *tableView;
@property(nonatomic, readonly) UIToolbar *bottomToolbar;
@property(nonatomic, assign) CGFloat panelHeight;

@property(nonatomic, weak) id<RMXOverlayViewDelegate> delegate;

- (void)hidePanel;
- (void)showMinimized;
- (void)showMaximized;
- (void)showAtDefaultHeight;

@end
