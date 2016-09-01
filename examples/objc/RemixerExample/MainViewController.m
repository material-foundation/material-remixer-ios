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

#import "MainViewController.h"

#import "Remixer.h"
#import "SpinningBoxViewController.h"

@implementation MainViewController {
  NSArray *_content;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.title = @"Remixer Examples";

  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

  _content = @[
    @[ @"Spinning Box Demo", @"SpinningBoxViewController" ],
    @[ @"Color Demo", @"ColorDemoViewController" ], @[ @"Font Demo", @"FontViewController" ]
  ];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  cell.textLabel.text = _content[indexPath.row][0];
  return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  Class class = NSClassFromString(_content[indexPath.row][1]);
  UIViewController *vc = [[class alloc] init];
  [self.navigationController pushViewController:vc animated:YES];
}

@end
