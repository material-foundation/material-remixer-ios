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

@implementation MainViewController {
  UICollectionViewFlowLayout *_layout;
  NSArray *_content;
}

- (instancetype)init {
  _layout = [[UICollectionViewFlowLayout alloc] init];
  self = [super initWithCollectionViewLayout:_layout];
  if (self) {
    self.title = @"Transactions";

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _layout.itemSize = CGSizeMake(self.view.bounds.size.width, 60);
  _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 100);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  cell.contentView.backgroundColor = [UIColor colorWithWhite:(100.0 / (indexPath.row + 2.0)) / 100.0 alpha:1];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                             withReuseIdentifier:@"header"
                                                                                    forIndexPath:indexPath];
  header.backgroundColor = [UIColor redColor];
  return header;
}

#pragma mark - UICollectionViewDelegate

@end
