//
//  NotificationListViewController.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/06/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "MainHomeController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NotificationListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) Config* config;
@property (weak, nonatomic) IBOutlet UITableView *tvNotify;
@property (weak, nonatomic) IBOutlet UITableView *tvMsgHead;
@property (weak, nonatomic) IBOutlet UITableView *tvMsgFor;
@property (weak, nonatomic) IBOutlet UICollectionView *clMsngrView;
@property (nonatomic,weak) IBOutlet MainHomeController *NvMain;
@property (nonatomic, strong) NSMutableArray* MessagesList;
@property (nonatomic, strong) NSMutableArray* MessageList;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrFrom;

@property (weak, nonatomic) IBOutlet UILabel *lblMsgFltrHadr;
@property (weak, nonatomic) IBOutlet UIView *vwTitle;
@property (weak, nonatomic) IBOutlet UIView *vwFilterWin;
@property (weak, nonatomic) IBOutlet UIView *vwScrbleWin;
@property (weak, nonatomic) IBOutlet UIView *vwrlpy;

@property (weak, nonatomic) IBOutlet UIImageView *vwImgProfile;

@property (weak, nonatomic) IBOutlet UIImageView *imgScrbView;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchDept;
@property (weak, nonatomic) IBOutlet UITextField *txtSearchMsg;
@property (weak, nonatomic) IBOutlet UITextField *cmbMsgHead;
@property (weak, nonatomic) IBOutlet UITextField *cmbMsgFor;
@property (weak, nonatomic) IBOutlet UITextField *txtMsgText;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnCloseSearch;
@end
NS_ASSUME_NONNULL_END
