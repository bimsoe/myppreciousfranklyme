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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setCollectionDelegate:(id<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>)collectionDelegate
{
  _collectionDelegate = collectionDelegate;
  [self.horizontalCollectionView setDelegate:collectionDelegate];
  [self.horizontalCollectionView setDataSource:collectionDelegate];
  [self.horizontalCollectionView reloadData];
}

@end
