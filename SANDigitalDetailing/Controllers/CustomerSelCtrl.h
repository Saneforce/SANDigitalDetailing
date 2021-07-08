//
//  LaunchAppVwCtrlr.h
//  SANAPP
//
//  Created by SANeForce.com on 08/06/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SignatureView.h"
#import "DrPolicyData.h"
#import "PNChartDelegate.h"
#import "PNChart.h"
#import "CLMDtPicker.h"
#import "ActivityDynamic/DynamicActivityCtrl.h"
@interface CustomerSelCtrl : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,UITableViewDelegate,UITableViewDataSource,PNChartDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, strong) DrPolicyData* drPolicy;
@property (nonatomic,strong) TdayPlDetail* TdayPl;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic, strong) AppSetupData* SetupData;
@property (weak, nonatomic) IBOutlet UILabel *lblCallTypCap;

@property (nonatomic) IBOutlet PNLineChart * lineChart;
@property (nonatomic, weak) IBOutlet SignatureView* signatureView;

@property (nonatomic,strong) NSArray *objHQList;
@property (nonatomic,strong) NSArray *objCallType;
@property (nonatomic,strong) NSArray *VstDetList;

@property (nonatomic,strong) NSMutableArray *objHospList;

@property (nonatomic,weak) IBOutlet UITableView *tbHQ;
@property (nonatomic,weak) IBOutlet UITableView *tbVstType;
@property (nonatomic,retain) IBOutlet UITableView *selHospFltr;

@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (nonatomic,retain) UITextField* txtHospSearch;

@property (nonatomic, weak) IBOutlet UILabel* lblHeadTitle;
@property (nonatomic, weak) IBOutlet UILabel* lSelCustName;
@property (nonatomic, weak) IBOutlet UILabel* lSelQual;
@property (nonatomic, weak) IBOutlet UILabel* lSelTownName;
@property (nonatomic, weak) IBOutlet UILabel* lSelSpeciality;
@property (nonatomic, weak) IBOutlet UILabel* lSelCategory;
@property (nonatomic, weak) IBOutlet UILabel* lSelDOB;
@property (nonatomic, weak) IBOutlet UILabel* lSelDOW;
@property (nonatomic, weak) IBOutlet UILabel* lSelMobile;
@property (nonatomic, weak) IBOutlet UILabel* lSelEmail;
@property (nonatomic, weak) IBOutlet UILabel* lblCallType;
@property (nonatomic, weak) IBOutlet UILabel* lblNxtVst;
@property (nonatomic, weak) IBOutlet UITextView* lSelHosAddr;
@property (nonatomic, weak) IBOutlet UITextView* lSelResAddr;
@property (nonatomic, weak) IBOutlet UIDatePicker* dtPickNxtVst;
@property (nonatomic, weak) IBOutlet UITextField* txtEmail;

@property (nonatomic, weak) IBOutlet UILabel* lSelPolyCustName;
@property (nonatomic, weak) IBOutlet UILabel* lSelPolyQual;
@property (nonatomic, weak) IBOutlet UILabel* lSelPolyAddr;
@property (nonatomic, weak) IBOutlet UILabel* lSelPolyLoc;
@property (nonatomic, weak) IBOutlet UILabel* lSelPolyPin;
@property (nonatomic, weak) IBOutlet UILabel* lSelPolyDist;

@property (nonatomic, weak) IBOutlet UISwitch* swAcptPoci;
@property (nonatomic, weak) IBOutlet UISwitch* swAcptMngmnt;
@property (nonatomic, weak) IBOutlet UISwitch* swAcptProf;
@property (nonatomic, weak) IBOutlet UISwitch* swAcptInvi;



@property (nonatomic, weak) IBOutlet UILabel* lChartTitle;

@property (nonatomic, weak) IBOutlet UILabel* lSelVstDt;
@property (nonatomic, weak) IBOutlet UILabel* lLatLng;
@property (nonatomic, weak) IBOutlet UITextView* lSelProdSamp;
@property (nonatomic, weak) IBOutlet UITextView* lSelProdPrmo;
@property (nonatomic, weak) IBOutlet UITextView* lSelInput;
@property (nonatomic, weak) IBOutlet UITextView* lSelFeedbk;
@property (nonatomic, weak) IBOutlet UITextView* lSelRems;

@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;

@property (nonatomic, weak) IBOutlet UIImageView* notifyInfo;

@property (nonatomic, weak) IBOutlet UIView* selDrPolicy;
@property (nonatomic, weak) IBOutlet UIView* selDrView;
@property (nonatomic, retain) IBOutlet UIView* vwModeModal;

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic,retain) UIButton* btnAllHosp;
@property (nonatomic,retain) UIButton* btnFilter;
@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic, weak) IBOutlet UIButton* btnSkipDet;
@property (nonatomic, weak) IBOutlet UIButton* btnActivity;
@property (nonatomic, weak) IBOutlet UIButton* btnCallTyp;
@property (nonatomic, weak) IBOutlet UIImageView* imgCallTyp;

@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblGPSSeg;
@property (weak, nonatomic) IBOutlet UILabel *lblGPSSegCap;





-(IBAction)CancelCallMeet:(id)sender;
-(IBAction)showCutomerList:(id)sender;
-(IBAction)goPreparePresentaion:(id)sender;
-(IBAction)searchDoctor:(id)sender;
@end
