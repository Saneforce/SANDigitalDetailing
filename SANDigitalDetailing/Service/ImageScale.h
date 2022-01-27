//
//  ImageScale.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 10/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ImageScale : NSObject
+ (UIImage *)imageWithImage:(UIImage*)sourceImage scaledToSize:(CGSize)newSize;
@end
