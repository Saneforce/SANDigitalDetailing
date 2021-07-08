//
//  eDetButton.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 25/08/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "eDetButton.h"
IB_DESIGNABLE
@implementation eDetButton

@synthesize paddingLeft;
@synthesize paddingRight;
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
       
        
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


- (void)drawRect:(CGRect)rect {
    [self customInit];
}

- (void)setNeedsLayout {
    [super setNeedsLayout];
    [self setNeedsDisplay];
}


- (void)prepareForInterfaceBuilder {
    
    [self customInit];
}

- (void)customInit {
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0,paddingLeft, 0.0, paddingRight)];
}

@end
