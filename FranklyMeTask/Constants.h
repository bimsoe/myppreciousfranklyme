//
//  Constants.h
//  FranklyMeTask
//
//  Created by Pankaj Sharma on 21/05/15.
//  Copyright (c) 2015 Pankaj Sharma. All rights reserved.
//

#ifndef FRANKLYMETASK_CONSTANTS_H
#define FRANKLYMETASK_CONSTANTS_H
#import <UIKit/UIKit.h>

#pragma mark - Color Defines
#define BROWNISH_COLOR  [UIColor colorWithRed:0.749f green:0.4f blue:0.161f alpha:1.0f]
#define WHITISH_COLOR   [UIColor colorWithRed:0.937f green:0.937f blue:0.937f alpha:1.0f]
#define PINKISH_COLOR   [UIColor colorWithRed:0.969f green:0.925f blue:0.898f alpha:1.0f]
#define YELLOWISH_COLOR [UIColor colorWithRed:0.957f green:0.957f blue:0.91f alpha:1.0f]
#define GRAYISH_COLOR   [UIColor colorWithRed:0.733f green:0.733f blue:0.733f alpha:1.0f]
#define DARK_BLACK_COLOR        [UIColor blackColor]
#define LIGHT_BLACK_COLOR       [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f]
#define EXTRA_LIGHT_BLACK_COLOR  [UIColor colorWithRed:0.6f green:0.6f blue:0.6f alpha:1.0f]

#pragma mark - Image Defines

#define GET_FONT(size) [UIFont systemFontOfSize:size]

typedef void(^CompletionBlockVoid)(void);

#define INT2STR(num)  [NSString stringWithFormat:@"%li", (long int)num]

#pragma mark - Debug
#if DEBUG
  #define PS_LOG(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])
#else
  #define PS_LOG(...)
#endif

#endif
