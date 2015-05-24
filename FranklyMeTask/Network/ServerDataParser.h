//
//  ServerDataParser.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CelebData;
@interface ServerDataParser : NSObject
+ (instancetype)sharedManager;
- (CelebData *)celebDataFromJSON:(NSDictionary *)jsonDictionary;
- (NSArray *)categoryDataArrayFromServerJSON:(NSData *)jsonData; /**< Returns array of @a CelebCategory objects */
@end
