//
//  UIBorderLabel.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/11/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "UIBorderLabel.h"

@implementation UIBorderLabel

@synthesize topInset, leftInset, bottomInset, rightInset;
-(void) drawTextInRect:(CGRect)rect{
    //UIEdgeInsets insets = {self.topInset, self.leftInset, self.bottomInset, self.rightInset};
    UIEdgeInsets insets = {10, 10, 10, 10};
    
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
    
}
@end
