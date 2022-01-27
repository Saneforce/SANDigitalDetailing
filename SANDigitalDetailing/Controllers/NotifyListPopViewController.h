//
//  NotifyListPopViewController.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/10/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MainHomeController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NotifyListPopViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tvNotify;
@property (nonatomic,weak) IBOutlet MainHomeController *NvMain;

@end

NS_ASSUME_NONNULL_END
