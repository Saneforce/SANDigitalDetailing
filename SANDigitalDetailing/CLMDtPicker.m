//
//  CLMDtPicker.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 22/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "CLMDtPicker.h"

@implementation CLMDtPicker
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}
-(void)awakeFromNib{
    [self customInit];
    [super awakeFromNib];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self customInit];
 
 return [super drawRect:rect];
}

- (void)drawTextInRect:(CGRect)rect{
    [self customInit];
    return [super drawTextInRect:rect];
}

- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}
- (void)customInit {
    self.font=[UIFont fontWithName:@"Poppins-Regular" size:12.0];
   // self.textColor=[UIColor greenColor];
}
@end
