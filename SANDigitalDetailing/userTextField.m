//
//  userTextField.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 26/08/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "userTextField.h"

@implementation userTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIEdgeInsets insets = {0, 15, 0, 0};
        self.edgeInsets = insets;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        UIEdgeInsets insets = {0, 15, 0, 0};
        self.edgeInsets = insets;
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}
@end
