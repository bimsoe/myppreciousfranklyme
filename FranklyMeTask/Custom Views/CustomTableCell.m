//
//  CustomTableCell.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "CustomTableCell.h"

@interface CustomTableCell ()
@end

@implementation CustomTableCell

- (void)awakeFromNib {
  // Initialization code
  if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
    [self setLayoutMargins:UIEdgeInsetsZero];
  }  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)prepareForReuse
{
  [self.horizontalCollectionView setContentOffset:CGPointZero];
}

- (void)setRowNumber:(NSInteger)rowNumber
{
  _rowNumber = rowNumber;
  //also get the caption
  [self.sectionLabel setText:[self.celebCategoryRowDataSource captionForRow:rowNumber]];
  [self.horizontalCollectionView reloadData];
}


- (CelebViewCell *)celebViewCellAtIndex:(NSInteger)celebViewIndex
{
  NSIndexPath *celbViewIndexPath = [NSIndexPath indexPathForItem:celebViewIndex inSection:0];
  return (CelebViewCell *) [self.horizontalCollectionView cellForItemAtIndexPath:celbViewIndexPath];
}


#pragma mark - UICollectionViewDelegateFlowLayout -

#pragma mark - UICollectionViewDataSource -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
  return [self.celebCategoryRowDataSource numberOfItemsForRow:self.rowNumber];
  
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CustomCellIdentifier = @"CelebViewCell";
  CelebViewCell *celebCell = (CelebViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CustomCellIdentifier forIndexPath:indexPath];
  [celebCell.celebView setDelegate:self.celebCategoryRowDataSource];
  [celebCell.celebView setDataSource:self.celebCategoryRowDataSource];
  NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:self.rowNumber];
  [celebCell.celebView setCelebIndexPath:newIndexPath];
  [celebCell refresh];
  return celebCell;
}

@end
