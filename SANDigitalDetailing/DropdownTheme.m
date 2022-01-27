//
//  DropdownTheme.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/12/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import "DropdownTheme.h"

@implementation DropdownTheme

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
    UIImage *image = [UIImage imageNamed:@"DwnArrw"];
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (__bridge id) image.CGImage;
    imageLayer.frame = CGRectMake(self.frame.size.width-16,(self.frame.size.height/2)-4,  8 , 8);
    [self.layer addSublayer:imageLayer];
    
    self.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    self.layer.borderWidth=0.5f;
    self.layer.borderColor=[UIColor colorWithRed:0.647 green:0.651 blue:0.675 alpha:1.00].CGColor;//[UIColor blackColor].CGColor;//[[UIColor colorWithRed:0.890 green:0.890 blue:0.894 alpha:1.00] CGColor];
    self.layer.cornerRadius=5;
    
    
   // UIView *spaceLeft =[[UIView alloc] initWithFrame: CGRectMake(0,0,  10 , self.frame.size.height)];
   // spaceLeft.backgroundColor=[UIColor redColor];
   // [self addSubview:spaceLeft];
}
@end
