//
//  CelebData.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "CelebData.h"
#import "SettingsManager.h"

@implementation CelebCategory

@end


#pragma mark - CelebData -
@implementation CelebData
- (UIImage *)celebImage
{
  NSString *imagePath = [[SettingsManager sharedManager] pathOfImageForCeleb:self.celebId];
  if (imagePath) {
    return [UIImage imageWithContentsOfFile:imagePath];
  }
  
  return nil;
}

- (NSString *)celebDisplayName
{
  NSMutableString *displayName = [NSMutableString string];
  if (self.celebFirstName.length) {
    [displayName appendString:self.celebFirstName];
  }
  
  if (self.celebLastName.length) {
    [displayName appendFormat:@" %@", self.celebLastName];
  }
  
  return displayName;
}

@end
