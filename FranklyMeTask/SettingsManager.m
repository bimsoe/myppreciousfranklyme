//
//  SettingsManager.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "SettingsManager.h"

NSString * const CelebInfoFetchUrl       = @"http://api.frankly.me/search/default";

@interface SettingsManager ()
@end

@implementation SettingsManager

+ (instancetype)sharedManager
{
  static SettingsManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (instancetype)init
{
  if ((self = [super init])) {
  }
  return self;
}


- (NSString *)urlEncodedString:(NSString *)str
{
  return [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}


- (NSURL *)apiForGettingCelebInfoForCategory:(NSString *)category
{
  NSString *apiUrlStr = nil;
  if (category == nil) {
    //for all the categories
    apiUrlStr = CelebInfoFetchUrl;
  } else {
    //can add some URL for fetching specific categories
  }
  return [NSURL URLWithString:[self urlEncodedString:apiUrlStr]];
}

- (NSString *)cachesDirectoryPath {
  NSString* path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
  
  if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
  }
  
  return path;
}


- (NSString *)writeImageData:(NSData *)imageData forCelebId:(NSString *)celebId
{
  NSString *path = [self pathOfImageForCeleb:celebId];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
  }
  
  BOOL success = [[NSFileManager defaultManager] createFileAtPath:path contents:imageData attributes:nil];
//   = [imageData writeToFile:path atomically:YES];
  if (success) {
    return path;
  }
  
  return nil;
}

- (NSString *)pathOfImageForCeleb:(NSString *)celebId
{
  return [[self cachesDirectoryPath] stringByAppendingPathComponent:celebId];
}


//- (UIImage *)imageForCeleb:(NSString *)celebId
//{
//  return [UIImage imageWithContentsOfFile:[self pathOfImageForCeleb:celebId]];
//}

@end
