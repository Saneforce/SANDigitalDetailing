//
//  SANTheme.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 11/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SANTheme : NSObject

+ (NSString*)boldFont;
+ (NSString*)mainFont;
+ (UIColor *)mainColor;
+ (UIColor*)foregroundColor;
+ (UIFont*)getToastHeaderFont;
+ (UIColor*)getToastBackgroundColor;
+ (UIColor*) getToastTextColor;
@end
