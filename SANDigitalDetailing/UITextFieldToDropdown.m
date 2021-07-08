//
//  UITextFieldToDropdown.m
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 25/12/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import "UITextFieldToDropdown.h"

@implementation UITextFieldToDropdown

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       // UIEdgeInsets insets = {0, 15, 0, 0};
        //self.edgeInsets = insets;
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    UIImage *image = [UIImage imageNamed:@"DwnArrw"];
    CALayer *imageLayer = [CALayer layer];
    imageLayer.contents = (__bridge id) image.CGImage;
    imageLayer.frame = CGRectMake(self.frame.size.width-16,(self.frame.size.height/2)-4,  8 , 8);
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0,0, self.frame.size.width  , self.frame.size.height);
    NSString *sAction;
    for (id target in self.allTargets) {
         NSArray *actions = [self actionsForTarget:target
                                          forControlEvent:UIControlEventTouchUpInside];
         for (NSString *action in actions) {
             sAction=action;
              [btn addTarget:target action:NSSelectorFromString(action) forControlEvents:UIControlEventTouchUpInside];
         }
    }
    //[btn addTarget:self action:NSSelectorFromString(sAction)  forControlEvents:UIControlEventTouchUpInside];
    [btn.layer addSublayer:imageLayer];
    [self addSubview:btn];
    
    //self.titleEdgeInsets=UIEdgeInsetsMake(0, 5, 0, 0);
    self.layer.borderWidth=0.5f;
    self.layer.borderColor=[UIColor colorWithRed:0.647 green:0.651 blue:0.675 alpha:1.00].CGColor;//[UIColor blackColor].CGColor;//[[UIColor colorWithRed:0.890 green:0.890 blue:0.894 alpha:1.00] CGColor];
    self.layer.cornerRadius=5;
    
    
   // UIView *spaceLeft =[[UIView alloc] initWithFrame: CGRectMake(0,0,  10 , self.frame.size.height)];
   // spaceLeft.backgroundColor=[UIColor redColor];
   // [self addSubview:spaceLeft];
}
@end
