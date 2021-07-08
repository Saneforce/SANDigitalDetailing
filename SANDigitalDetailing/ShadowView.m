//
//  ShadowView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 03/10/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIEdgeInsets insets = {0.5f, 0.5f, -1.5f, 0.5f};
        self.edgeInsets = insets;
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        
        UIEdgeInsets insets = {0.5f, 0.5f, -1.5f, 0.5f};
        self.edgeInsets = insets;
    }
    return self;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    self.layer.shadowRadius  = 0.5f;
    //_vwTitle.layer.shadowColor   = [UIColor colorWithRed:176.f/255.f green:199.f/255.f blue:226.f/255.f alpha:1.f].CGColor;
    self.layer.shadowColor   = [UIColor colorWithRed:0.f/255.f green:0.f/255.f blue:0.f/255.f alpha:0.5f].CGColor;
    
    self.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    self.layer.shadowOpacity = 0.11f;
    self.layer.masksToBounds = NO;

    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, self.edgeInsets)];
    self.layer.shadowPath    = shadowPath.CGPath;
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
