//
//  ServerDataParser.m
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 23/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#import "ServerDataParser.h"
#import "CelebData.h"

//Keys
NSString * const CD_ResultsKey       = @"results"; //returns NSArray
NSString * const CCD_CategoryNameKey  = @"category_name"; //returns NSString
NSString * const CCD_UsersKey         = @"users"; //returns NSArray of CelebData
//User Keys
//CD_ -> CelebData
NSString * const CD_UserIDKey        = @"id"; //returns NSString
NSString * const CD_UsernameKey      = @"username"; //returns NSString
NSString * const CD_UserBioKey       = @"bio"; //returns NSString
NSString * const CD_UserFirstNameKey = @"first_name"; //returns NSString
NSString * const CD_UserLastNameKey  = @"last_name"; //returns NSString
NSString * const CD_UserGenderKey    = @"gender"; //returns NSString
NSString * const CD_UserImageKey     = @"profile_picture"; //returns url as NSString
NSString * const CD_UserTitleKey     = @"user_title"; //returns NSString; Unuser
NSString * const CD_UserTypeKey      = @"user_type"; //returns NSNumber; Unused as of now


#define NULLIFY_IF_NOT_STRING(str)  ([str isKindOfClass:[NSString class]] ? str : nil)
  
@implementation ServerDataParser
+ (instancetype)sharedManager
{
  static ServerDataParser *sharedMyManager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMyManager = [[self alloc] init];
  });
  return sharedMyManager;
}


- (id)init
{
  if (self = [super init]) {
  }
  return self;
}



- (CelebCategory *)celebCategoryDataFromJson:(NSDictionary *)jsonDictionary
{
  CelebCategory *celebCategory = [[CelebCategory alloc] init];
  celebCategory.celebCategoryName = jsonDictionary[CCD_CategoryNameKey];
  //now add CelebData objects
  NSArray *celebsArrayJson = jsonDictionary[CCD_UsersKey]; //array of celeb data json
  NSMutableArray *celebDataArray = [NSMutableArray arrayWithCapacity:celebsArrayJson.count];
  for (NSDictionary *celebDataJson in celebsArrayJson) {
    CelebData *celebData = [self celebDataFromJSON:celebDataJson];
    //add category name
    celebData.celebCategoryName = celebCategory.celebCategoryName;
    [celebDataArray addObject:celebData];
  }
  
  celebCategory.celebs = celebDataArray;

  return celebCategory;
}


- (CelebData *)celebDataFromJSON:(NSDictionary *)jsonDictionary
{
  CelebData *celebData = [[CelebData alloc] init];
  celebData.celebId = jsonDictionary[CD_UserIDKey];
  celebData.celebUsername = jsonDictionary[CD_UsernameKey];
  celebData.celebBio = NULLIFY_IF_NOT_STRING(jsonDictionary[CD_UserBioKey]);
  celebData.celebGender = [self genderEnumFromString:NULLIFY_IF_NOT_STRING(jsonDictionary[CD_UserGenderKey])];
  celebData.celebFirstName = NULLIFY_IF_NOT_STRING(jsonDictionary[CD_UserFirstNameKey]);
  celebData.celebLastName = NULLIFY_IF_NOT_STRING(jsonDictionary[CD_UserLastNameKey]);
  celebData.celebTitle = NULLIFY_IF_NOT_STRING(jsonDictionary[CD_UserTitleKey]);
  celebData.celebImageURL = [NSURL URLWithString:jsonDictionary[CD_UserImageKey]];
  return celebData;
}


- (CelebGender)genderEnumFromString:(NSString *)genderStr
{
  CelebGender gender = CelebGenderUnspecified;//default
  if ([genderStr isEqualToString:@"M"]) {
    gender = CelebGenderMale;
  } else if ([genderStr isEqualToString:@"F"]) {
    gender = CelebGenderFemale;
  }
  
  return gender;
}


- (NSArray *)categoryDataArrayFromServerJSON:(NSData *)jsonData
{
  NSDictionary *productsDictionary = [self parseJSON:jsonData];
  if (productsDictionary == nil) {
    return nil;
  }
  NSArray *categoriesArrayJson = productsDictionary[CD_ResultsKey]; //array of caregory data json
  NSMutableArray *celebCategoryArray = [NSMutableArray arrayWithCapacity:categoriesArrayJson.count];
  for (NSDictionary *celebCategoryJson in categoriesArrayJson) {
    [celebCategoryArray addObject:[self celebCategoryDataFromJson:celebCategoryJson]];
  }
  NSLog(@"Parsing Done : %@", celebCategoryArray);
  return celebCategoryArray;
}



- (NSDictionary *)parseJSON:(NSData *)json_data
{
  if (json_data == nil || json_data.length == 0) {
    return nil;
  }
  
  NSError *parsingError = nil;
  id result = [NSJSONSerialization JSONObjectWithData:json_data
                                              options:0
                                                error:&parsingError];
  if (parsingError) {
    NSLog(@"JSON Pasring error : \n%@", parsingError.localizedDescription);
  }
  return (NSDictionary *)result;
}

@end
