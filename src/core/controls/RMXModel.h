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

NS_ASSUME_NONNULL_BEGIN

/** The available types of UI controls to display in the overlay for a given remix. */
typedef NS_ENUM(NSInteger, RMXModelType) {
  /** A button control stored with key __RemixControlTypeButton__ */
  kRMXModelTypeButton = 0,

  /** A color picker control stored with key __RemixControlTypeColorPicker__ */
  kRMXModelTypeColorPicker = 1,

  /** A segmented control stored with key __RemixControlTypeSegmented__ */
  kRMXModelTypeSegmented = 2,

  /** A slider control stored with key __RemixControlTypeSlider__ */
  kRMXModelTypeSlider = 3,

  /** A stepper control stored with key __RemixControlTypeStepper__ */
  kRMXModelTypeStepper = 4,

  /** A switch control stored with key __RemixControlTypeSwitch__ */
  kRMXModelTypeSwitch = 5,

  /** A button control stored with key __RemixControlTypeTextPicker__ */
  kRMXModelTypeTextPicker = 6
};

#pragma mark - <RMXModel>

/** A protocol that provides a common set of properties and methods for controls. */
@protocol RMXModel <NSObject>
@required

/** The control model type. */
@property(nonatomic, readonly) RMXModelType modelType;

/** The title associated with this control. */
@property(nonatomic, strong) NSString *title;

/** The default value of the control. Restoring will reset to this value. */
@property(nonatomic, strong) NSNumber *defaultValue;

/** Whether the control should send value change events after completed or during dragging. */
@property(nonatomic) BOOL delaysCommit;

/** The dictionary json represenation of this object. */
- (NSDictionary *)toJSON;

@end

#pragma mark - <RMXModelItemList>

/**
 A protocol that provides a common set of properties and methods for a control that uses
 a list of items for its model.
 */
@protocol RMXModelItemList <RMXModel>
@required

/** The array of items for this control. */
@property(nonatomic, strong) NSArray<id> *itemList;

@end

#pragma mark - <RMXModelRange>

/**
 A protocol that provides a common set of properties and methods for a control that uses
 a range of values for its model.
 */
@protocol RMXModelRange <RMXModel>
@optional

/** The amount to increment/decrement the selected value of this control. */
@property(nonatomic) CGFloat stepValue;

@required

/** The minimum value available to this control. */
@property(nonatomic) CGFloat minimumValue;

/** The maximum value available to this control. */
@property(nonatomic) CGFloat maximumValue;

@end

NS_ASSUME_NONNULL_END
