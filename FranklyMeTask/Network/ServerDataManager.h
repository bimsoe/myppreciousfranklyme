//
//  ServerDataManager.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompletionBlockVoid)(NSError *);
typedef void(^CompletionBlockArray)(NSArray *celebCategories, NSError *error);

@protocol ServerDataReceiver
@required
///Sends Array of @a CelebCategory objects
- (void)doneFetchingCelebCategories:(NSArray *)celebCategories error:(NSError *)error;
- (void)imageDownloadedAtLocation:(NSString *)image_path forCelebId:(NSString *)celebId;
@end


@class CelebData;
@interface ServerDataManager : NSObject
@property (nonatomic, weak) id<ServerDataReceiver> serverDataReceiver;/**< Right now kept just one; otherwise we 
                                                                       can have a dictionary with @{category:array of receivers} pair */
@property (nonatomic, readonly) BOOL fetchingCelebsInfo;
+ (instancetype)sharedManager;
- (void)fetchCelebsInfoForAllCategories:(id<ServerDataReceiver>)receiver completionBlock:(CompletionBlockArray)completion;
- (void)downloadImageForCeleb:(CelebData *)celebData completionBlock:(CompletionBlockVoid)completion;
@end
