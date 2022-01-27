//
//  CVColor.h
//  SANAPP
//
//  Created by SANeForce.com on 14/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CVColor : NSObject

- (UIColor *)getUIColorObjectFromHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
- (unsigned int)intFromHexString:(NSString *)hexStr;
@end
