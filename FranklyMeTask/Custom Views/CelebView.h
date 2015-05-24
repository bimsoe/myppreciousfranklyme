//
//  CelebView.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CelebData.h"

#pragma mark -
@protocol CelebDelegate <NSObject>
@optional
- (void)celebFollowButtonPressedAtIndexPath:(NSIndexPath *)indexPath;
- (void)celebImageTappedAtIndexPath:(NSIndexPath *)indexPath;
- (void)requestReloadForCelebAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark -
@protocol CelebDatasource <NSObject>
@required
- (CelebData *)dataForCelebAtIndexPath:(NSIndexPath *)indexPath;
@end

#pragma mark -
@class CelebView;
FOUNDATION_EXPORT NSString *CelebCellIdentifier;
@interface CelebViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet CelebView *celebView;
/**
 * Make sure you call this AFTER setting @b delegate & @b dataSource & @b celebIndexPath of self.celebView
 *  @code [self.celebView updateWithCelebData:[self.dataSource dataForCelebAtIndexPath:self.celebIndexPath]]; @endcode
 */
- (void)refresh;
@end

#pragma mark -
@interface CelebView : UIView
@property (copy, nonatomic) NSIndexPath *celebIndexPath; /**< (Section -> Parent Row number of table view cell) */
@property (weak, nonatomic) id<CelebDelegate> delegate;
@property (weak, nonatomic) id<CelebDatasource> dataSource;
- (void)updateWithCelebData:(CelebData *)celeb_data;
@end
