//
//  userLabel.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 26/08/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "userLabel.h"

@implementation userLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 10, 0, 0};
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}
@end
