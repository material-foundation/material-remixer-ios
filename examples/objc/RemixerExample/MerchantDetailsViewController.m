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

#import "Remixer.h"

#import "ColorUtils.h"
#import "HeaderStatsView.h"
#import "MerchantDetailsHeaderView.h"
#import "SectionHeaderView.h"
#import "TransactionCell.h"
#import "TransactionDetailsCell.h"

@interface MerchantDetailsViewController ()<UICollectionViewDelegate,
                                            UICollectionViewDataSource,
                                            UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) MerchantDetailsHeaderView *headerView;
@property(nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic, strong) UICollectionView *collectionView;

@end

@implementation MerchantDetailsViewController {
  RMXColorVariable *_appColorVariable;
  RMXStringVariable *_sectionTitleVariable;
  RMXRangeVariable *_cellHeightVariable;
}

- (instancetype)initWithMerchantData:(NSObject *)data {
  self = [super init];
  if (self) {
    self.title = @"Merchant Name";

    _headerView = [[MerchantDetailsHeaderView alloc] initWithFrame:CGRectZero];

    _layout = [[UICollectionViewFlowLayout alloc] init];
    _layout.minimumLineSpacing = 0;
    _layout.sectionHeadersPinToVisibleBounds = YES;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor colorWithWhite:0.91 alpha:1];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[TransactionCell class]
        forCellWithReuseIdentifier:@"cell"];
    [_collectionView registerClass:[TransactionDetailsCell class]
        forCellWithReuseIdentifier:@"detailsCell"];
    [_collectionView registerClass:[SectionHeaderView class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:@"header"];

    __weak MerchantDetailsViewController *weakSelf = self;
    _appColorVariable =
        [RMXColorVariable colorVariableWithKey:@"appTintColor"
                                  defaultValue:[ColorUtils appColorOptions][0]
                               limitedToValues:[ColorUtils appColorOptions]
                                   updateBlock:^(RMXColorVariable *variable, UIColor *selectedValue) {
                                     weakSelf.headerView.backgroundColor = selectedValue;
                                   }];
    _sectionTitleVariable =
        [RMXStringVariable stringVariableWithKey:@"sectionTitle"
                                    defaultValue:@"Transaction Details"
                                 limitedToValues:nil
                                     updateBlock:^(RMXStringVariable *variable, NSString *selectedValue) {
                                       [weakSelf.collectionView reloadData];
                                     }];
    _cellHeightVariable =
        [RMXRangeVariable rangeVariableWithKey:@"cellHeight"
                                  defaultValue:60.0
                                      minValue:52.0
                                      maxValue:68.0
                                     increment:4.0
                                   updateBlock:^(RMXNumberVariable *variable, CGFloat selectedValue) {
                                     [weakSelf.layout invalidateLayout];
                                   }];
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
    cell.backgroundColor = _collectionView.backgroundColor;
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
  header.titleLabel.text =
      indexPath.section == 0 ? _sectionTitleVariable.selectedValue : @"Other Transactions";
  return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout*)collectionViewLayout
    sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CGFloat height = indexPath.section == 0 ? _cellHeightVariable.selectedFloatValue * 2.5 :
      _cellHeightVariable.selectedFloatValue;
  return CGSizeMake(self.view.bounds.size.width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
  CGFloat verticalInset = section == 0 ? 0 : 10;
  return UIEdgeInsetsMake(verticalInset, 0, verticalInset, 0);
}

@end
