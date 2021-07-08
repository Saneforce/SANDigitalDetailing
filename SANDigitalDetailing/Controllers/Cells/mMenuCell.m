//
//  mMenuCell.m
//  SANAPP
//
//  Created by SANeForce.com on 06/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import "mMenuCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation mMenuCell

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
    /*self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.font = [UIFont fontWithName:@"Avenir-Black" size:20.0f];*/
    //UIColor* mainColor = [UIColor colorWithRed:47.0/255 green:168.0/255 blue:228.0/255 alpha:1.0f];
    
    //self.bgView.backgroundColor = mainColor;
    //self.backgroundColor=mainColor;
    self.bgView.layer.cornerRadius = 3.0f;
}

@end
