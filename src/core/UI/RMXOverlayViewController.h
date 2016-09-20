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

/** A view controller that shows the controls for refining the values of the Remixes. */
@interface RMXOverlayViewController : UIViewController

/** Shows the overlay panel with the Remixer controls. */
- (void)showPanel;

/** Forces a reload of the Remixer controls. */
- (void)reloadData;

@end
