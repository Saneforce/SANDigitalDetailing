//
//  UnlistedCusSelCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 05/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "BaseViewController.h"
#import "ActivityDynamic/DynamicActivityCtrl.h"
@interface UnlistedCusSelCtrl : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,PNChartDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic,strong) TdayPlDetail* TdayPl;
@property (nonatomic, strong) AppSetupData* SetupData;

@property (nonatomic) IBOutlet PNLineChart * lineChart;

@property (nonatomic,strong) NSArray *objHQList;
@property (nonatomic,strong) NSArray *VstDetList;

@property (nonatomic,weak) IBOutlet UITableView *tbHQ;
@property (nonatomic,weak) IBOutlet UITableView *tbOptSel;


@property (nonatomic, weak) IBOutlet UITextField* searchBox;

@property (nonatomic, weak) IBOutlet UILabel* lblNewDrCap;
@property (nonatomic, weak) IBOutlet UILabel* lblHeadTitle;
@property (nonatomic, weak) IBOutlet UILabel* lSelCustName;
@property (nonatomic, weak) IBOutlet UITextView* lSelAddr;
@property (nonatomic, weak) IBOutlet UILabel* lSelTownName;
@property (nonatomic, weak) IBOutlet UILabel* lSelQual;
@property (nonatomic, weak) IBOutlet UILabel* lSelPhone;
@property (nonatomic, weak) IBOutlet UILabel* lSelMobile;
@property (nonatomic, weak) IBOutlet UILabel* lSelSpec;
@property (nonatomic, weak) IBOutlet UILabel* lSelCate;


@property (nonatomic, weak) IBOutlet UILabel* lSelVstDt;
@property (nonatomic, weak) IBOutlet UITextView* lSelProd;
@property (nonatomic, weak) IBOutlet UITextView* lSelInput;
@property (nonatomic, weak) IBOutlet UITextView* lSelFeedbk;
@property (nonatomic, weak) IBOutlet UITextView* lSelRems;
@property (nonatomic, weak) IBOutlet UITextView* nwDrsAddr;

@property (nonatomic, weak) IBOutlet UITextField* nwDrName;
@property (nonatomic, weak) IBOutlet UITextField* nwDrPincd;
@property (nonatomic, weak) IBOutlet UITextField* nwDrPhone;
@property (nonatomic, weak) IBOutlet UITextField* nwDrMobile;



@property (nonatomic, weak) IBOutlet UILabel* lChartTitle;

@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;
@property (nonatomic,weak) IBOutlet DropdownTheme *SelCmbBtn;
@property (nonatomic,weak) IBOutlet DropdownTheme *CmbQual;
@property (nonatomic,weak) IBOutlet DropdownTheme *CmbClass;
@property (nonatomic,weak) IBOutlet DropdownTheme *CmbCate;
@property (nonatomic,weak) IBOutlet DropdownTheme *CmbSpec;
@property (nonatomic,weak) IBOutlet DropdownTheme *CmbTerr;


@property (nonatomic, weak) IBOutlet UIView* selUnDrView;
@property (nonatomic, weak) IBOutlet UIView* nwUnDrView;
@property (nonatomic, weak) IBOutlet UIView* nwUnDrOptSels;



@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;


@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnNew;
@property (nonatomic, weak) IBOutlet UIButton* btnActivity;

-(IBAction)CancelCallMeet:(id)sender;
-(IBAction)showUnCutomerList:(id)sender;
-(IBAction)goPreparePresentaion:(id)sender;
-(IBAction)searchUnDoctor:(id)sender;


@end
