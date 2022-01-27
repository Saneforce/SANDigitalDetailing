//
//  mCustomerCell.h
//  SANAPP
//
//  Created by SANeForce.com on 10/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface mCustomerCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UIButton* btnBtnDets;
@property (nonatomic, weak) IBOutlet UILabel* lCustName;
@property (nonatomic, weak) IBOutlet UILabel* lTownName;
@property (nonatomic, weak) IBOutlet UILabel* lSpeciality;
@property (nonatomic, weak) IBOutlet UILabel* lCategory;
@property (nonatomic, weak) IBOutlet UIImageView *selImgID;
@property (nonatomic, weak) IBOutlet UIImageView *selCusImg;
@property (nonatomic, weak) IBOutlet UILabel* lTagDet;

@property (nonatomic, weak) IBOutlet UIView* bgView;

@end
