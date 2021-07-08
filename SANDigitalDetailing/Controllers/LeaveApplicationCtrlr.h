//
//  LeaveApplicationCtrlr.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 19/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaveApplicationCtrlr : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIDatePicker* FDate;
@property (nonatomic, weak) IBOutlet UIDatePicker* TDate;
@property (nonatomic, weak) IBOutlet UILabel* NODL;
@property (nonatomic, weak) IBOutlet UITextView* txtRem;
@property (nonatomic, weak) IBOutlet UITextView* txtAddOnLv;

@property (nonatomic, weak) IBOutlet UITableView* LvStatus;

@property (strong, nonatomic) IBOutlet UISegmentedControl * LvType;
@end
