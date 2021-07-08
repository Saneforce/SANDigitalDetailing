//
//  SpinnerTheme.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 18/11/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "SpinnerTheme.h"

@implementation SpinnerTheme
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib{
    UIImage *image = [UIImage imageNamed:@"insidebottomrightcorner"];    
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (__bridge id) image.CGImage;
    imageLayer.frame = CGRectMake(self.frame.size.width-15,self.frame.size.height-15,  15 , 15);
    [self.layer addSublayer:imageLayer];
}
@end
