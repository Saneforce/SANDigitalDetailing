//
//  SANTheme.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "SANTheme.h"

@implementation SANTheme

+ (NSString*)boldFont{
    return @"Avenir-Black";
}

+ (NSString*)mainFont{
    return @"Avenir-Book";
}

+ (UIColor*)mainColor{
    return [UIColor blackColor];
}

+ (UIColor*)foregroundColor{
    return [UIColor colorWithRed:255.0/255 green:255.0/255 blue:255.0/255 alpha:1];
}
+ (UIFont*)getToastHeaderFont{
    return [UIFont fontWithName:@"HelveticaNeue" size:16.0];
}
+ (UIColor*)getToastBackgroundColor{
    return [UIColor blackColor];
}
+ (UIColor*) getToastTextColor{
    return [UIColor whiteColor];
}
@end
