//
//  MsngrCell.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 26/09/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MsngrCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMsgFor;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgbox;
@property (weak, nonatomic) IBOutlet UILabel *lblMsgDt;
@property (weak, nonatomic) IBOutlet UIView *MsgViewer;
@property (weak, nonatomic) IBOutlet UIView *AttchFileViewer;
@property (weak, nonatomic) IBOutlet UIImageView *MsgVwrImg;
@property (weak, nonatomic) IBOutlet UIButton *btnReply;
@end

NS_ASSUME_NONNULL_END
