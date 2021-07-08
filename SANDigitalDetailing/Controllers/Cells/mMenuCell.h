//
//  mMenuCell.h
//  SANAPP
//
//  Created by SANeForce.com on 06/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mMenuCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel* titleLabel;

@property (nonatomic, weak) IBOutlet UIView* bgView;
@property (nonatomic, weak) IBOutlet UIImageView* bLogoImg;
@property (nonatomic,assign) int tagID;
@property (nonatomic, weak) IBOutlet UILabel* LblText;
@property (nonatomic, weak) IBOutlet UILabel* LblHiLetText;

@property (nonatomic, weak) IBOutlet UIButton* btnSync;
@property (nonatomic, weak) IBOutlet UIButton* btnEdit;
@property (nonatomic, weak) IBOutlet UIButton* btnDel;
@end
