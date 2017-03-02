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

#import "TransactionsListViewController.h"

#import "SectionHeaderView.h"
#import "TransactionCollectionViewCell.h"

@interface TransactionsListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UILabel *totalLabel;
@property(nonatomic, strong) UILabel *timePeriodLabel;

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TransactionsListViewController

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"Transactions";

    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.backgroundColor =
        [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_totalLabel setFont:[UIFont systemFontOfSize:42.0]];
    [_totalLabel setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    [_totalLabel setText:@"$2,301.99"];
    [_headerView addSubview:_totalLabel];
    _timePeriodLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_timePeriodLabel setFont:[UIFont systemFontOfSize:11.0]];
    [_timePeriodLabel setTextColor:[UIColor colorWithWhite:1 alpha:1]];
    [_timePeriodLabel setText:@"THIS MONTH"];
    [_headerView addSubview:_timePeriodLabel];

    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;
    _layout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
    _layout.sectionHeadersPinToVisibleBounds = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TransactionCollectionViewCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[SectionHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"header"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view addSubview:_headerView];
  [self.view addSubview:_collectionView];
}

- (void)viewDidLayoutSubviews {
  _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 176);
  [_totalLabel sizeToFit];
  _totalLabel.center = CGPointMake(_headerView.bounds.size.width / 2.0,
                                   _headerView.bounds.size.height / 2.0 + 8);
  [_timePeriodLabel sizeToFit];
  _timePeriodLabel.center =
      CGPointMake(_totalLabel.center.x,
                  CGRectGetMaxY(_totalLabel.frame) + 4 + _timePeriodLabel.bounds.size.height / 2.0);

  _collectionView.frame = CGRectMake(0, 176,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height - 176);
  _layout.itemSize = CGSizeMake(self.view.bounds.size.width, 60);
  _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 48);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TransactionCollectionViewCell *cell =
      [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  UICollectionReusableView *header =
      [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:@"header"
                                                     forIndexPath:indexPath];
  return header;
}

@end
