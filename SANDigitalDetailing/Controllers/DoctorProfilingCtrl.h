//
//  DoctorProfilingCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 15/10/18.
//  Copyright © 2018 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "DrProfileData.h"
#import "UserControls.h"
#import <FSCalendar/FSCalendar.h>
NS_ASSUME_NONNULL_BEGIN

@interface DoctorProfilingCtrl : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,FSCalendarDelegate,FSCalendarDataSource,UserControlDelegate,UIDocumentPickerDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, strong) DrProfileData* DrProfData;
@property (nonatomic,strong) LocationDetail* locationData;
@property (nonatomic,strong) AppSetupData* SetupData;

@property (nonatomic,strong) NSArray *objHQList;
@property (weak, nonatomic) IBOutlet UIView *vwSelBxModal;

@property (nonatomic, weak) IBOutlet UIView* selDrView;
@property (nonatomic, weak) IBOutlet UIView* vwProfArea;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* nsScrollHeight;

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic,weak) IBOutlet UITableView *tbHQ;
@property (nonatomic,weak) IBOutlet UITableView *tbPoten;
@property (nonatomic,weak) IBOutlet UITableView *tbSegm;
@property (nonatomic,weak) IBOutlet UITableView *selOptTableView;
@property (nonatomic,retain) IBOutlet UITableView *selTypeMode;

@property (weak, nonatomic) IBOutlet UILabel *lblDrName;
@property (weak, nonatomic) IBOutlet UILabel *lblTittle;
@property (weak, nonatomic) IBOutlet UILabel *lblPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblBrick;
@property (weak, nonatomic) IBOutlet UILabel *lblSelDt;
@property (weak, nonatomic) IBOutlet UILabel *lblSelHead;
@property (weak, nonatomic) IBOutlet UILabel *lblSelHead1;


@property (nonatomic, weak) IBOutlet UILabel *lblCity;
@property (nonatomic, weak) IBOutlet UILabel *lblMob;
@property (nonatomic, weak) IBOutlet UILabel *lblPhone;
@property (nonatomic, weak) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd2;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd3;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd4;
@property (weak, nonatomic) IBOutlet UILabel *lblAdd5;
@property (weak, nonatomic) IBOutlet UILabel *lblCapPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblCapBrick;

@property (nonatomic, weak) IBOutlet UIButton* btnMale;
@property (nonatomic, weak) IBOutlet UIButton* btnFemale;
@property (nonatomic, weak) IBOutlet UIButton* btnQual;
@property (nonatomic, weak) IBOutlet UIButton* btnDCate;
@property (nonatomic, weak) IBOutlet UIButton* btnSpec;
@property (nonatomic, weak) IBOutlet UIButton* btnType;
@property (nonatomic, weak) IBOutlet UIButton* btnTar;

@property (weak, nonatomic) IBOutlet UIButton *btnCate;
@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;
@property (nonatomic,weak) IBOutlet UIButton *btnSelectbx;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnVstDys;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnVstSes;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnVstAvP;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnVstClP;

@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (nonatomic, weak) IBOutlet UITextField* txtInSearch;
@property (nonatomic, retain) IBOutlet UITextField* txtSearch;
@property (nonatomic, weak) IBOutlet UIView *vwSelectbx;
@property (nonatomic, weak) IBOutlet UITableView *tbSelectBx;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd1;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd2;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd3;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd4;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd5;
@property (nonatomic, weak) IBOutlet UITextField* txtMob;
@property (nonatomic, weak) IBOutlet UITextField* txtPhone;
@property (nonatomic, weak) IBOutlet UITextField* txtEmail;
@property (nonatomic, weak) IBOutlet UITextField* txtDOBD;
@property (nonatomic, weak) IBOutlet UITextField* txtDOBM;
@property (nonatomic, weak) IBOutlet UITextField* txtDOWD;
@property (nonatomic, weak) IBOutlet UITextField* txtDOWM;
@property (nonatomic, weak) IBOutlet UITextField* txtDOBY;
@property (nonatomic, weak) IBOutlet UITextField* txtDOWY;
@property (nonatomic, weak) IBOutlet UITextField* txtDrDistrict;
@property (nonatomic, weak) IBOutlet UITextField* txtDrCity;


@property (nonatomic, weak) IBOutlet UIView* vwAdCtrl;
@property (nonatomic, weak) IBOutlet UIView* vwAddrDets;
@property (nonatomic, weak) IBOutlet UIView* vwPotan;
@property (nonatomic, weak) IBOutlet UIView* vwSeg;
@property (nonatomic, weak) IBOutlet UIView* vwVstDets;
@property (nonatomic, weak) IBOutlet UIView* vwModalView;
@property (nonatomic, weak) IBOutlet UIView* vwClndrView;
@property (nonatomic, weak) IBOutlet UIView* vwCmbView;
@property (nonatomic, retain) IBOutlet UIView* vwCtrlsView;
@property (nonatomic, retain) IBOutlet UIView* vwModeModal;

@property (nonatomic, weak) IBOutlet UIPickerView *pikFT;
@property (nonatomic, weak) IBOutlet UIPickerView *pikTT;

@property (weak, nonatomic) NSString* CustCode;

-(IBAction)showCutomerList:(id)sender;
-(IBAction)searchDoctor:(id)sender;
@end

NS_ASSUME_NONNULL_END
