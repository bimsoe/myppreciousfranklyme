//
//  CustomTableCell.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebView.h"

@protocol CelebCategoryRowProtocol <CelebDatasource>
- (NSInteger)numberOfItemsForRow:(NSInteger)row;
- (NSString *)captionForRow:(NSInteger)row;
@end



@interface CustomTableCell : UITableViewCell <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *horizontalCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;
@property (nonatomic) NSInteger rowNumber;
@property (nonatomic, weak) id<CelebDelegate, CelebCategoryRowProtocol> celebCategoryRowDataSource;
- (CelebViewCell *)celebViewCellAtIndex:(NSInteger)celebViewIndex;
@end
