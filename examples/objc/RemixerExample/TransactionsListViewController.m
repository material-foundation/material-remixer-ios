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

#import "HeaderStatsView.h"
#import "MerchantDetailsViewController.h"
#import "SectionHeaderView.h"
#import "TransactionCell.h"

@interface TransactionsListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) HeaderStatsView *stats;

@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation TransactionsListViewController

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"Transactions";
    self.navigationItem.backBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:@""
                                         style:UIBarButtonItemStylePlain
                                        target:nil
                                        action:nil];

    _headerView = [[UIView alloc] initWithFrame:CGRectZero];
    _headerView.backgroundColor =
        [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    _stats = [[HeaderStatsView alloc] initWithFrame:CGRectZero];
    _stats.timePeriod = @"THIS MONTH";
    _stats.amountValue = @"$3,201.99";
    [_headerView addSubview:_stats];

    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;
    _layout.sectionInset = UIEdgeInsetsMake(10, 0, 10, 0);
    _layout.sectionHeadersPinToVisibleBounds = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TransactionCell class]
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
  _stats.frame = CGRectMake(0,
                            54,
                            self.view.bounds.size.width,
                            _headerView.bounds.size.height - 54);

  _collectionView.frame = CGRectMake(0, 176,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height - 176);
  _layout.itemSize = CGSizeMake(self.view.bounds.size.width, 60);
  _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 48);
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self.navigationController pushViewController:[[MerchantDetailsViewController alloc] init]
                                       animated:YES];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  TransactionCell *cell =
      [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  SectionHeaderView *header =
      [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:@"header"
                                                     forIndexPath:indexPath];
  header.titleLabel.text = @"Recent Transactions";
  return header;
}

@end
