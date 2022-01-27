//
//  CLMButton.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 03/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import "CLMButton.h"

@implementation CLMButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.cornerRadius=5.0f;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius=5.0f;
        
    }
    return self;
}

@end
