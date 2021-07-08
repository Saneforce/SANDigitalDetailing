//
//  EditDateSelectionCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 31/05/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MainHomeController.h"
NS_ASSUME_NONNULL_BEGIN

@interface EditDateSelectionCtrl : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,weak) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic,weak) IBOutlet UITableView *tbDTSel;
@property (nonatomic,weak) IBOutlet MainHomeController *NvMain;
@end

NS_ASSUME_NONNULL_END
