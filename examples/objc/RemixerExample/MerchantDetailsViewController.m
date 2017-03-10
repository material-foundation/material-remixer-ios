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

#import "MerchantDetailsViewController.h"

#import "HeaderStatsView.h"
#import "SectionHeaderView.h"
#import "TransactionCell.h"
#import "TransactionDetailsCell.h"

@interface MerchantDetailsHeaderView : UIView

@property(nonatomic, strong) HeaderStatsView *thisMonthStats;
@property(nonatomic, strong) HeaderStatsView *thisYearStats;

@end

@implementation MerchantDetailsHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor =
        [UIColor colorWithRed:18/255.0 green:121/255.0 blue:194/255.0 alpha:1];
    _thisMonthStats = [[HeaderStatsView alloc] initWithFrame:CGRectZero];
    _thisMonthStats.timePeriod = @"THIS MONTH";
    _thisMonthStats.amountValue = @"$201.99";
    [self addSubview:_thisMonthStats];
    _thisYearStats = [[HeaderStatsView alloc] initWithFrame:CGRectZero];
    _thisYearStats.timePeriod = @"THIS YEAR";
    _thisYearStats.amountValue = @"$1,092.32";
    [self addSubview:_thisYearStats];
  }
  return self;
}

- (void)layoutSubviews {
  _thisMonthStats.frame = CGRectMake(0, 54, self.bounds.size.width / 2.0, self.bounds.size.height - 54);
  _thisYearStats.frame = CGRectMake(self.bounds.size.width / 2.0, 54, self.bounds.size.width / 2.0, self.bounds.size.height - 54);
}

@end

@interface MerchantDetailsViewController ()<UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) MerchantDetailsHeaderView *headerView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MerchantDetailsViewController

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"Merchant Name";

    _headerView = [[MerchantDetailsHeaderView alloc] initWithFrame:CGRectZero];

    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;
    _layout.sectionHeadersPinToVisibleBounds = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TransactionCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[TransactionDetailsCell class]
        forCellWithReuseIdentifier:@"detailsCell"];
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
  _headerView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 144);
  _collectionView.frame = CGRectMake(0, 144,
                                     self.view.bounds.size.width,
                                     self.view.bounds.size.height - 144);
  _layout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 48);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  return section == 0 ? 1 : 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                           cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    TransactionDetailsCell *cell =
        [self.collectionView dequeueReusableCellWithReuseIdentifier:@"detailsCell"
                                                       forIndexPath:indexPath];
    return cell;
  } else {
    TransactionCell *cell =
        [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.iconVisible = NO;
    cell.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    cell.primaryLabel.text = @"Saturday, Dec 25";
    cell.secondaryLabel.text = @"Posted";
    return cell;
  }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  SectionHeaderView *header =
      [self.collectionView dequeueReusableSupplementaryViewOfKind:kind
                                              withReuseIdentifier:@"header"
                                                     forIndexPath:indexPath];
  header.titleLabel.text = indexPath.section == 0 ? @"Transaction Details" : @"Other Transactions";
  return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  return CGSizeMake(self.view.bounds.size.width, indexPath.section == 0 ? 160 : 60);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  CGFloat verticalInset = section == 0 ? 0 : 10;
  return UIEdgeInsetsMake(verticalInset, 0, verticalInset, 0);
}

@end
