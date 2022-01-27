//
//  StockistSelCtrl.h
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
@interface StockistSelCtrl : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,PNChartDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic,strong) TdayPlDetail* TdayPl;
@property (nonatomic, strong) AppSetupData* SetupData;

@property (nonatomic) IBOutlet PNLineChart * lineChart;

@property (nonatomic,strong) NSArray *objHQList;
@property (nonatomic,strong) NSArray *VstDetList;

@property (nonatomic,weak) IBOutlet UITableView *tbHQ;

@property (nonatomic, weak) IBOutlet UITextField* searchBox;

@property (nonatomic, weak) IBOutlet UILabel* lblHeadTitle;
@property (nonatomic, weak) IBOutlet UILabel* lSelCustName;
@property (nonatomic, weak) IBOutlet UITextView* lSelAddr;
@property (nonatomic, weak) IBOutlet UILabel* lSelTownName;
@property (nonatomic, weak) IBOutlet UILabel* lSelContact;
@property (nonatomic, weak) IBOutlet UILabel* lSelPhone;
@property (nonatomic, weak) IBOutlet UILabel* lSelMobile;
@property (nonatomic, weak) IBOutlet UILabel* lSelFax;
@property (nonatomic, weak) IBOutlet UILabel* lSelEmail;


@property (nonatomic, weak) IBOutlet UILabel* lSelVstDt;
@property (nonatomic, weak) IBOutlet UITextView* lSelProd;
@property (nonatomic, weak) IBOutlet UITextView* lSelInput;
@property (nonatomic, weak) IBOutlet UITextView* lSelFeedbk;
@property (nonatomic, weak) IBOutlet UITextView* lSelRems;

@property (nonatomic, weak) IBOutlet UILabel* lChartTitle;

@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;


@property (nonatomic, weak) IBOutlet UIView* selStkView;

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;


@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnActivity;
-(IBAction)showStockistList:(id)sender;

-(IBAction)CancelCallMeet:(id)sender;
-(IBAction)searchDoctor:(id)sender;

@end
