//
//  TourPlanEntry.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 18/11/17.
//  Copyright © 2017 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface TourPlanEntry : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) AppSetupData* SetupData;
@property (nonatomic, strong) TPEntryData* TPEntryDet;

@property (weak, nonatomic) IBOutlet UIView *vfSelWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsVfselTop;

@property (weak, nonatomic) IBOutlet UITableView *tvOptList;
@property (weak, nonatomic) IBOutlet UITableView *tvHQList;
@property (weak, nonatomic) IBOutlet UITableView *tvClusterList;
@property (retain, nonatomic) IBOutlet UITableView *tvHospList;
@property (weak, nonatomic) IBOutlet UITableView *tvMultiSel;

@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnCurrMnTP;
@property (nonatomic, weak) IBOutlet UIButton* btnNxtMnTP;
@property (nonatomic, weak) IBOutlet UIButton* saveDayPl;
@property (nonatomic, weak) IBOutlet UIButton* submitTP;
@property (nonatomic, weak) IBOutlet UIButton* ApproveTP;
@property (nonatomic, weak) IBOutlet UIButton* RejectTP;
@property (nonatomic, weak) IBOutlet UICollectionView* CalenderView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;
@property (nonatomic, weak) IBOutlet UILabel* MonYrCaption;
@property (nonatomic, weak) IBOutlet UILabel* lblDyMonYr;
@property (nonatomic, weak) IBOutlet UILabel* lblDyDay;
@property (nonatomic, weak) IBOutlet UILabel* lblDyWeekNm;
@property (nonatomic, weak) IBOutlet UILabel* lblTit;
@property (nonatomic, weak) IBOutlet UILabel* lblCluster;
@property (nonatomic, weak) IBOutlet UILabel* lblDoctor;
@property (nonatomic, weak) IBOutlet UILabel* lblChemist;

@property (nonatomic, weak) IBOutlet UIView* vwPlPerDayModal;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (nonatomic, weak) IBOutlet UITextField* msearchBox;
@property (nonatomic, weak) IBOutlet UITextView* txtRemarks;

@property (nonatomic, weak) IBOutlet UIButton* btnWTName;
@property (nonatomic, weak) IBOutlet UIButton* btnWTName2;

@property (nonatomic, weak) IBOutlet UIButton* btJointWk;
@property (nonatomic, weak) IBOutlet UIButton* btDoctor;
@property (nonatomic, weak) IBOutlet UIButton* btChm;
@property (nonatomic, weak) IBOutlet UIButton* btnCluster;
@property (nonatomic, weak) IBOutlet UIButton* btnHQList;

@property (nonatomic, retain) UIButton* btnHosp;

@property (nonatomic, weak) IBOutlet UIView* vwMMultiSel;
@property (nonatomic, retain) NSString* selJWCds;
@property (nonatomic, retain) NSString* selJWNms;
@property (nonatomic, retain) NSString* selDrsCds;
@property (nonatomic, retain) NSString* selDrsNms;
@property (nonatomic, retain) NSString* selChmCds;
@property (nonatomic, retain) NSString* selChmNms;

@end
