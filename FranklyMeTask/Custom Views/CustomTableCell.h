//
//  CustomTableCell.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *horizontalCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (nonatomic, weak) id<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource> collectionDelegate;
@end
