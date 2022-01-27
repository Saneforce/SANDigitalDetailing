//
//  ActivityViewCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 24/12/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@interface ActivityViewCtrl : UIViewController<UITableViewDelegate,UITableViewDataSource,TBSelectionBxCellDelegate>
@property (nonatomic, strong) UserDetails* UserDet;

@property (nonatomic, strong) NSArray* CustomerList;
@property (nonatomic, strong) NSArray* SpeakerList;
@property (nonatomic, strong) NSArray* ParticipantList;
@property (nonatomic, strong) NSArray* IndicationList;
@property (nonatomic, strong) NSArray* ProductList;
@property (nonatomic, strong) NSMutableArray* InputList;

@property (nonatomic, strong) NSArray* objOptList;
@property (nonatomic, strong) NSMutableArray* SelOptList;
@property (nonatomic, strong) NSArray* SelDoctorList;
@property (nonatomic, strong) NSArray* SelPartiList;
@property (nonatomic, strong) NSArray* SelProductList;
@property (nonatomic, strong) NSArray* SelIndicationList;
@property (nonatomic, strong) NSArray* SelInputList;
@property (nonatomic, strong) NSMutableArray* OTOEntryList;
@property (nonatomic, strong) NSArray* mConsultList;


@property(nonatomic,weak) NSString *eType;
@property (nonatomic,weak) IBOutlet UILabel *lblTitle;
@property (nonatomic,weak) IBOutlet UILabel *lblDrCap;
@property (nonatomic,weak) IBOutlet UILabel *lblOthCap;
@property (nonatomic,weak) IBOutlet UILabel *lblIndic;
@property (nonatomic,weak) IBOutlet UILabel *lblNofVol;
@property (nonatomic,weak) IBOutlet UILabel *lblSelWinCap;
@property (nonatomic,weak) IBOutlet UITextField *txtIndic;
@property (nonatomic,weak) IBOutlet UITextField *txtDoc;
@property (nonatomic,weak) IBOutlet UITextField *txtNoOfVolunteer;

@property (nonatomic,weak) IBOutlet UITextField *searchBox;
@property (nonatomic,weak) IBOutlet UIView *vwParticipantDet;
@property (nonatomic,weak) IBOutlet UIView *vwProductDet;
@property (nonatomic,weak) IBOutlet UIView *vwInputDet;
@property (nonatomic,weak) IBOutlet UIView *vwDtDet;
@property (nonatomic,weak) IBOutlet UIView *vwDocDet;
@property (nonatomic,weak) IBOutlet UIView *vwSelWin;
@property (nonatomic,weak) IBOutlet UIView *vwStaffDetWin;
@property (nonatomic,weak) IBOutlet UIView *vwSGTCMEWin;
@property (nonatomic,weak) IBOutlet UIView *vwOneToOneWin;
@property (nonatomic,weak) IBOutlet UIView *vwSTPWin;
@property (nonatomic,weak) IBOutlet UIView *vwModal;
@property (nonatomic,weak) IBOutlet UITableView *tvSelOpt;
@property (nonatomic,weak) IBOutlet UITableView *tvPartiList;
@property (nonatomic,weak) IBOutlet UITableView *tvProdList;
@property (nonatomic,weak) IBOutlet UITableView *tvInputList;
@property (nonatomic,weak) IBOutlet UITableView *tvOTOEntry;

@end

NS_ASSUME_NONNULL_END
