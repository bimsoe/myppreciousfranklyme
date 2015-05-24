//
//  ServerDataManager.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "ServerDataManager.h"
#import "ServerDataParser.h"
#import "SettingsManager.h"
#import "CelebData.h"

#define MAX_PARALLEL_REQUEST  5

@interface ServerDataManager () <NSURLSessionDataDelegate>
@property (nonatomic, readwrite) BOOL fetchingCelebsInfo;
@property (nonatomic, strong) NSURLSession *serverSession;
//@property (nonatomic, strong) NSURLSession *imageDownloadSession;
@property (nonatomic, strong) NSOperationQueue *fetchQueue;
//@property (nonatomic, strong) NSOperationQueue *imageQueue;
@property (nonatomic, strong) NSMutableArray *currentImageDownloads ; /**< Array of @b CelebData.celebId whose image is  being downloaded right now */
@end



@implementation ServerDataManager
+ (instancetype)sharedManager
{
  static ServerDataManager *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}

- (id)init {
  if (self = [super init]) {
    [self initBasicStuff];
  }
  return self;
}


- (void)initBasicStuff
{
  _fetchQueue = [[NSOperationQueue alloc] init];
  [_fetchQueue setMaxConcurrentOperationCount:MAX_PARALLEL_REQUEST];
  _currentImageDownloads = [NSMutableArray arrayWithCapacity:5];//say
  _serverSession = [self createURLSessionWithDelegateQueue:self.fetchQueue];
}


- (NSURLSession *)createURLSessionWithDelegateQueue:(NSOperationQueue *)queue
{
  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];//or it can be made a background session
  [sessionConfiguration setHTTPMaximumConnectionsPerHost:MAX_PARALLEL_REQUEST];
  NSURLSession *sharedSession = [NSURLSession sessionWithConfiguration:sessionConfiguration
                                                              delegate:self
                                                         delegateQueue:queue];
  return sharedSession;
}


- (void)fetchCelebsInfoForAllCategories:(id<ServerDataReceiver>)receiver completionBlock:(CompletionBlockArray)completion
{
  //check if already downloading
  if (self.fetchingCelebsInfo) {
    NSLog(@"Already Fetching");
    return;
  }
  
  self.serverDataReceiver = receiver;
  NSURL *urlForCategory = [[SettingsManager sharedManager] apiForGettingCelebInfoForCategory:nil];
  if (urlForCategory == nil) {
    return;
  }
  
  NSURLRequest *urlRequest = [NSURLRequest requestWithURL:urlForCategory];
  NSLog(@"Url : %@", urlForCategory);
  
  //now send the request
  NSURLSessionDataTask *fetchDataTask =
  [self.serverSession dataTaskWithRequest:urlRequest
                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                          //parse 'em to get array of CelebCategory objects
                          NSArray *celebCategories = [[ServerDataParser sharedManager] categoryDataArrayFromServerJSON:data];
                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (error == nil) {
                              [self.serverDataReceiver doneFetchingCelebCategories:celebCategories error:error];
                            }
                            if (completion) {
                              completion(celebCategories, error);
                            }
                          }];
                          _fetchingCelebsInfo = NO;
                        }];
  [fetchDataTask resume];
  [fetchDataTask setTaskDescription:@"Fetching Categories Info"];
  _fetchingCelebsInfo = YES;  
}


- (void)downloadImageForCeleb:(CelebData *)celebData completionBlock:(CompletionBlockVoid)completion
{
  if (celebData.celebImageURL == nil) {
    //no can do
    return;
  }
  //check if already downloading
  if ([self isDownloadingImageForCeleb:celebData.celebId]) {
    return;
  }
  
  //start download
  NSURLSessionDownloadTask *imageDownloadTask =
  [self.serverSession downloadTaskWithURL:celebData.celebImageURL
                        completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                          NSString *imagePath = nil;
                          if (error) {
                            NSLog(@"Some Error Occurred While Downloading image for celeb : %@; Error: %@",
                                   celebData.celebDisplayName, error);
                          } else {
                            //image downloaded
                            //write to file
                            imagePath = [[SettingsManager sharedManager] writeImageData:[NSData dataWithContentsOfURL:location]
                                                                             forCelebId:celebData.celebId];
                          }
                          
                          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            if (error == nil) {
                              [self.serverDataReceiver imageDownloadedAtLocation:imagePath forCelebId:celebData.celebId];
                            }
                            if (completion) {
                              completion(error);
                            }
                          }];
                        }];
  
  [imageDownloadTask resume];
  [imageDownloadTask setTaskDescription:celebData.celebDisplayName];
  //add to current downloads
  [self.currentImageDownloads addObject:celebData.celebId];
}


- (BOOL)isDownloadingImageForCeleb:(NSString *)celebId
{
  return ([self.currentImageDownloads indexOfObjectPassingTest:^BOOL(NSString *currentCelebId, NSUInteger idx, BOOL *stop) {
    return [currentCelebId isEqualToString:celebId];
  }] != NSNotFound);
}
@end
