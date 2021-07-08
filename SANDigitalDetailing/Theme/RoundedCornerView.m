//
//  RoundedCornerView.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 28/08/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "RoundedCornerView.h"

@implementation RoundedCornerView
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
