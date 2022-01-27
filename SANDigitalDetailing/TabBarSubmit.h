//
//  TabBarSubmit.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 02/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomerSelCtrl.h"

NS_ASSUME_NONNULL_BEGIN

@interface TabBarSubmit : UITabBar
@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic,strong) UINavigationController *NavCtrl;

@end

NS_ASSUME_NONNULL_END
