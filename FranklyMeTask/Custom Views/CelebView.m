//
//  CelebView.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "CelebView.h"
#import "SettingsManager.h"


#pragma mark - CelebViewCell
NSString *CelebCellIdentifier = @"CelebViewCell";
@implementation CelebViewCell
#if DEBUG
- (void)prepareForReuse
{
  [super prepareForReuse];
}
#endif

- (void)refresh
{
  [self.celebView updateWithCelebData:[self.celebView.dataSource dataForCelebAtIndexPath:self.celebView.celebIndexPath]];
}

@end


#pragma mark - 
#pragma mark - CelebView
@interface CelebView ()
{
  __weak CelebData *celebData;
  UITapGestureRecognizer *tapGesture;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (weak, nonatomic) IBOutlet UILabel *celebTitle;
@property (weak, nonatomic) IBOutlet UIButton *celebImageButton;
@property (weak, nonatomic) IBOutlet UIButton *celebFollowButton;
@property (weak, nonatomic) IBOutlet UIButton *celebCategoryButton;
@end

@implementation CelebView
- (void)awakeFromNib
{
  [super awakeFromNib];
  self.celebImageButton.layer.cornerRadius = self.celebImageButton.frame.size.width / 2;
}


- (void)updateWithCelebData:(CelebData *)celeb_data
{
  celebData = celeb_data;
  [self.celebTitle setText:celebData.celebDisplayName];
  [self.celebCategoryButton setTitle:celebData.celebCategoryName forState:UIControlStateNormal];
  [self.celebImageButton setImage:celebData.celebImage forState:UIControlStateNormal];
  [self.loadingIndicator stopAnimating];
  if (self.celebImageButton.imageView.image == nil) {
    [self.loadingIndicator startAnimating];
  } else {
    [self.loadingIndicator stopAnimating];
  }
}

- (IBAction)buttonPressed:(UIButton *)sender
{
  if (sender == self.celebFollowButton) {
    if ([self.delegate respondsToSelector:@selector(celebFollowButtonPressedAtIndexPath:)]) {
      [self.delegate celebFollowButtonPressedAtIndexPath:self.celebIndexPath];
    }
  } else if (sender == self.celebImageButton) {
    if ([self.delegate respondsToSelector:@selector(celebImageTappedAtIndexPath:)]) {
      [self.delegate celebImageTappedAtIndexPath:self.celebIndexPath];
    }
  }
}


#pragma mark - CATransitionDelegate
- (void)animationDidStart:(CAAnimation *)anim
{
  [[UIApplication sharedApplication] beginIgnoringInteractionEvents];  
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
  [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
