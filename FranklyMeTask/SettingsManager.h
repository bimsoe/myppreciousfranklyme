//
//  SettingsManager.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject
+ (instancetype)sharedManager;
- (NSURL *)apiForGettingCelebInfoForCategory:(NSString *)category; /**< Send nil to get for all categories */
- (NSString *)cachesDirectoryPath;
//- (UIImage *)imageForCeleb:(NSString *)celebId;
- (NSString *)pathOfImageForCeleb:(NSString *)celebId;
- (NSString *)writeImageData:(NSData *)imageData forCelebId:(NSString *)celebId;/**< @return the path to written file */
@end
