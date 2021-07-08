//
//  MasterDownloader.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 09/12/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface MasterDownloader : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UITableView *tvOptList;
@property (nonatomic, weak) IBOutlet UITableView* tvMasterList;
@property (weak, nonatomic) IBOutlet UIView *vfSelWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsVfselTop;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblHQName;
@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (nonatomic, weak) IBOutlet UIImageView* loaderImg;
@end
