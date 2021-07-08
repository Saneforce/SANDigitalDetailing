//
//  RCPAEntryCtrlr.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 14/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RCPAEntryCtrlr : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) TdayPlDetail* TdayPl;

@property (weak, nonatomic) IBOutlet UIView *vfSelWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsVfselTop;

@property (weak, nonatomic) IBOutlet UITableView *tvOptList;
@property (weak, nonatomic) IBOutlet UITableView *tvChemistList;
@property (weak, nonatomic) IBOutlet UITableView *tvComptList;
@property (weak, nonatomic) IBOutlet UITableView *tvRCPAList;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnSubmit;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (nonatomic, weak) IBOutlet UITextField* txtOPQty;
@property (nonatomic, weak) IBOutlet UITextField* txtOPRate;
@property (nonatomic, weak) IBOutlet UITextField* txtOPValue;

@property (weak, nonatomic) IBOutlet UILabel *lblOurPName;
@property (weak, nonatomic) IBOutlet UILabel *lblDoctorName;
@property (nonatomic, assign) NSString* DCREntryMode;

@end
