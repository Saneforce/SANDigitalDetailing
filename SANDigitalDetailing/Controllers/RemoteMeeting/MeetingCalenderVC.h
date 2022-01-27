//
//  MeetingCalenderVC.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 02/12/20.
//  Copyright © 2020 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "mSlideCell.h"
#import <MSAL/MSAL.h>
#import <MSGraphClientSDK/MSGraphClientSDK.h>
NS_ASSUME_NONNULL_BEGIN

@interface MeetingCalenderVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;

@property (nonatomic,strong) NSMutableArray* CalnDates;
@property (nonatomic,strong) NSMutableArray* PrevDates;
@property (nonatomic,strong) NSMutableArray* MeetDatas;
@property (nonatomic,strong) NSMutableArray* DayMeetDatas;

@property (nonatomic, weak) IBOutlet UIView* vwReqForm;
@property (nonatomic, weak) IBOutlet UIView* vwAddModalView;
@property (nonatomic, weak) IBOutlet UIView* vwAddSelView;
@property (nonatomic, weak) IBOutlet UIView* vwMeetDetails;
@property (nonatomic, weak) IBOutlet UITextField* txtSelSearch;
@property (nonatomic, weak) IBOutlet UITextField* txtCusSearch;
@property (nonatomic, weak) IBOutlet UITableView * selTableView;
@property (nonatomic, weak) IBOutlet UITableView * tbReqCusts;
@property (nonatomic, weak) IBOutlet UITableView * tbMeetDetails;
@property (nonatomic, weak) IBOutlet UICollectionView* CalenderView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic, weak) IBOutlet UIDatePicker* DtTmPicker;
@property (nonatomic, weak) IBOutlet UILabel* MonYrCaption;
@property (nonatomic, weak) IBOutlet UILabel* lblTitleDets;
@property (nonatomic, weak) IBOutlet UILabel* selWinCaption;
@property (nonatomic, weak) IBOutlet UILabel* lblEvntTitle;
@property (nonatomic, weak) IBOutlet UILabel* lblDispSF;

@property (nonatomic, weak) IBOutlet UITextField* txEventReqTitle;
@property (nonatomic, weak) IBOutlet UITextField* txEventTitle;
@property (nonatomic, weak) IBOutlet UITextField* txEventCust;
@property (nonatomic, weak) IBOutlet UITextField* txEventDtTm;
@property (nonatomic, weak) IBOutlet UITextField* txEventDur;
@property (nonatomic, weak) IBOutlet UITextField* txEventParticipants;

@property (nonatomic, weak) IBOutlet UITextView* txEventDesc;

@property (nonatomic, weak) IBOutlet UIButton* btnClose;
@property (nonatomic, weak) IBOutlet UIButton* btnSave;
@property (nonatomic, weak) IBOutlet UIButton* btnCancel;

@property (nonatomic, weak) IBOutlet UISegmentedControl* segEvtType;

@end

NS_ASSUME_NONNULL_END
