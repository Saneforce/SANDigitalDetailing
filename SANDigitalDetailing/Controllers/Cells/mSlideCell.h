//
//  mSlideCell.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 30/08/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mSlideCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UILabel* bkCap;
@property (nonatomic, weak) IBOutlet UILabel* lblSubTitle;
@property (nonatomic, weak) IBOutlet UIView* bgView;
@property (nonatomic, weak) IBOutlet UIImageView* ImgView;
@property BOOL Selected;
@end
