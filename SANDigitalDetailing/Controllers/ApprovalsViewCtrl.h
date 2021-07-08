//
//  ApprovalsViewCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface ApprovalsViewCtrl : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UserDetails* UserDet;
@property (nonatomic,strong) TPEntryData* TPEntryDet;

@property (weak, nonatomic) IBOutlet UIView *vfSelWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsVfselTop;

@property (nonatomic, weak) IBOutlet UITableView* tvLvApprvList;
@property (nonatomic, weak) IBOutlet UITableView* tvTPPendingList;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UITextView* txRejRem;
@end
