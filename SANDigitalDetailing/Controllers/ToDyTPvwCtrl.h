//
//  ToDyTPvwCtrl.h
//  SANAPP
//
//  Created by SANeForce.com on 16/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ToDyTPvwCtrl : KeyboardView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) BaseViewController* OBJErr;
@property (nonatomic,strong) TdayPlDetail* TdayPl;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic,weak) IBOutlet NSLayoutConstraint *ViewHeightConstraint;

@property (nonatomic,strong) NSArray *objWTList;
@property (nonatomic,strong) NSArray *objClusterList;
@property (nonatomic,strong) NSArray *objHQList;
@property (nonatomic,strong) NSString *SelHQ;

@property (nonatomic,weak) IBOutlet UIButton *btnSelWT;
@property (nonatomic,weak) IBOutlet UIButton *btnSelCluster;
@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;
@property (nonatomic,weak) IBOutlet UIButton *bSvTP;

@property (nonatomic,weak) IBOutlet UITableView *tbWorkType;
@property (nonatomic,weak) IBOutlet UITableView *tbHQ;
@property (nonatomic,weak) IBOutlet UITableView *tbCluster;

@property (nonatomic,weak) IBOutlet UITextView *tRemarks;
@property (nonatomic,weak) IBOutlet UILabel *lblTitle;
@property (nonatomic,weak) IBOutlet UILabel *lblEDt;

@property (nonatomic,strong) NSMutableDictionary *objAppSvData;
@property (weak, nonatomic) IBOutlet UILabel *vwTitle;

-(IBAction)saveTodayPlan:(id)sender;
-(IBAction) openSelWorkType:(id)sender;
-(IBAction) openSelCluster:(id)sender;
@end
