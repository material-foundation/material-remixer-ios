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

/** Identifiers for the different types of data Variables can hold. */
static NSString *const RMXDataTypeBoolean = @"__DataTypeBoolean__";
static NSString *const RMXDataTypeColor = @"__DataTypeColor__";
static NSString *const RMXDataTypeNumber = @"__DataTypeNumber__";
static NSString *const RMXDataTypeString = @"__DataTypeString__";

/** Identifiers for the different types of constraints. */
static NSString *const RMXConstraintTypeNone = @"__ConstratintTypeNone__";
static NSString *const RMXConstraintTypeList = @"__ConstratintTypeList__";
static NSString *const RMXConstraintTypeRange = @"__ConstratintTypeRange__";

/** Identifiers for the different types of controls Variables can have. */
static NSString *const RMXControlTypeButton = @"__ControlTypeButton__";
static NSString *const RMXControlTypeColorList = @"__ControlTypeColorList__";
static NSString *const RMXControlTypeColorInput = @"__ControlTypeColorInput__";
static NSString *const RMXControlTypeSegmented = @"__ControlTypeSegmented__";
static NSString *const RMXControlTypeSlider = @"__ControlTypeSlider__";
static NSString *const RMXControlTypeStepper = @"__ControlTypeStepper__";
static NSString *const RMXControlTypeSwitch = @"__ControlTypeSwitch__";
static NSString *const RMXControlTypeTextList = @"__ControlTypeTextList__";
static NSString *const RMXControlTypeTextInput = @"__ControlTypeTextInput__";

/** Keys for the JSON dictionary that contains the data for a Variable. */
static NSString *const RMXDictionaryKeyKey = @"key";
static NSString *const RMXDictionaryKeySelectedValue = @"selectedValue";
static NSString *const RMXDictionaryKeyLimitedToValues = @"limitedToValues";
static NSString *const RMXDictionaryKeyDataType = @"dataType";
static NSString *const RMXDictionaryKeyControlType = @"controlType";
static NSString *const RMXDictionaryKeyTitle = @"title";
static NSString *const RMXDictionaryKeyMinValue = @"minimumValue";
static NSString *const RMXDictionaryKeyMaxValue = @"maximumValue";
static NSString *const RMXDictionaryKeyIncrement = @"increment";
