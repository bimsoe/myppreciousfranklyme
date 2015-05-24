//
//  CelebData.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CelebCategory : NSObject
@property (nonatomic, copy) NSString *celebCategoryName;
@property (nonatomic, strong) NSArray *celebs; /**< Array of @a CelebData objects */
@end


#pragma mark - CelebData -
typedef NS_ENUM(short, CelebGender){
  CelebGenderUnspecified = -1,
  CelebGenderMale,
  CelebGenderFemale,
  CelebGenderThird
};

@interface CelebData : NSObject
@property (nonatomic, copy) NSString *celebId; //bfb88fb5cb0d4ca4bd102c87f42b7498
@property (nonatomic, copy) NSString *celebUsername; //e.g. "RuchikaBatra",
@property (nonatomic, copy) NSString *celebBio; //e.g. "Lifestyle Blogger, loves fashion, beauty & spirituality."

@property (nonatomic, copy) NSString *celebLastName; // "Sharma",
@property (nonatomic, copy) NSString *celebFirstName; // "Pankaj"
@property (nonatomic, copy) NSString *celebTitle; // "Blogger"
@property (nonatomic) CelebGender celebGender; /**< @see CelebGender */
@property (nonatomic, strong) NSURL *celebImageURL; //https://s3.amazonaws.com/franklymestorage/bfb88fb5cb0d4ca4bd102c87f42b7498/photos/ebdf2da2ce4611e494a5020e433c1e0d.jpeg
@property (nonatomic, copy) NSString *celebCategoryName; /**< Or it can be made a weak relationship with @a CelebCategory object */
@end


@interface CelebData (Helper)
@property (nonatomic, readonly) UIImage *celebImage; /**< Will be fetched from local cache if available */
@property (nonatomic, readonly) NSString *celebDisplayName; /**< Concat of first & last name */
@end
