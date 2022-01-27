//
//  WindowView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 07/12/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "WindowView.h"

@implementation WindowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    CALayer *layer = self.layer;
    layer.cornerRadius= 5.0f;
    //layer.borderWidth = 1.0f;
    
    layer.shadowOffset = CGSizeMake(1, 1);
    layer.shadowColor = [[UIColor blackColor] CGColor];
    layer.shadowRadius = 4.0f;
    layer.shadowOpacity = 0.80f;
    layer.shadowPath = [[UIBezierPath bezierPathWithRect:layer.bounds] CGPath];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
