//
//  FeedbackCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 04/07/16.
//  Copyright © 2016 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SignatureView.h"
#import "MainHomeController.h"
#import "ActivityDynamic/DynamicActivityCtrl.h"
@interface FeedbackCtrl : UIViewController  <UITableViewDelegate,UITableViewDataSource,TBSelectionBxCellDelegate,UITextFieldDelegate,UITextViewDelegate,UIPopoverPresentationControllerDelegate>

@property (nonatomic, weak) UserDetails* UserDet;
@property (nonatomic,strong) MissedEntryData *MissedEntry;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic,weak) MainHomeController* MCtrlr;
@property (nonatomic, strong) AppSetupData* SetupData;


@property (nonatomic, weak) IBOutlet StarRatingView* SRProdFeedbk;
@property (nonatomic, weak) IBOutlet SignatureView* signatureView;
@property (nonatomic, weak) IBOutlet UITextField* searchBox;

@property (weak, nonatomic) IBOutlet UIView *vfProdFeed1;
@property (weak, nonatomic) IBOutlet UIView *vfProdFeed;
@property (weak, nonatomic) IBOutlet UIView *vwRatingInf;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfProdFeedTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfProdFeedBottom;
@property (weak, nonatomic) IBOutlet UIView *vfSelWindow;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *VfBottomLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nsVfselTop;
@property (weak, nonatomic) IBOutlet UIView *vwQuryWin;

@property (weak, nonatomic) IBOutlet UITableView *tvOptList;
@property (weak, nonatomic) IBOutlet UITableView *tvAdCusList;
@property (weak, nonatomic) IBOutlet UITableView *tvProdList;
@property (weak, nonatomic) IBOutlet UITableView *tvInputList;
@property (weak, nonatomic) IBOutlet UITableView *tvAdProdList;
@property (weak, nonatomic) IBOutlet UITableView *tvAdInputList;
@property (weak, nonatomic) IBOutlet UITableView *tvJWList;
@property (weak, nonatomic) IBOutlet UITableView *tvFeedBk;
@property (weak, nonatomic) IBOutlet UITableView *tvFeedBk1;
@property (weak, nonatomic) IBOutlet UITableView *tvProdFeedBk;
@property (weak, nonatomic) IBOutlet UITableView *tvDepts;
@property (weak, nonatomic) IBOutlet UITableView *tvRatingInf;
@property (weak, nonatomic) IBOutlet UITableView *tvRatingInf1;

@property (weak, nonatomic) IBOutlet UITextView *txtRem;
@property (weak, nonatomic) IBOutlet UITextView *txtQuery;
@property (weak, nonatomic) IBOutlet UITextView *txtRatingFeed;
@property (weak, nonatomic) IBOutlet UITextView *txtRatingFeed1;

@property (weak, nonatomic) IBOutlet UIView *fProdFeed;
@property (weak, nonatomic) IBOutlet UIView *wFeedOpt;
@property (weak, nonatomic) IBOutlet UIView *wFeedOpt1;
@property (weak, nonatomic) IBOutlet UIView *ProdSelWin;
@property (weak, nonatomic) IBOutlet UIView *AdrDetsWin;
@property (weak, nonatomic) IBOutlet UILabel *lblCusName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProduct1;
@property (weak, nonatomic) IBOutlet UILabel *lblGroup;
@property (weak, nonatomic) IBOutlet UIButton *btnfeedbk;
@property (weak, nonatomic) IBOutlet UIButton *btnRCPA;
@property (weak, nonatomic) IBOutlet UIButton *btnFinal;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDept;

@property (weak, nonatomic) IBOutlet UIButton *btnAddAdCus;
@property (weak, nonatomic) IBOutlet UIButton *btnAddInp;
@property (weak, nonatomic) IBOutlet UIButton *btnAddProd;
@property (weak, nonatomic) IBOutlet UIButton *btnAddJoin;
@property (weak, nonatomic) IBOutlet UIButton *btnSndQry;
@property (nonatomic, weak) IBOutlet UIButton* btnActivity;
@property (nonatomic, weak) IBOutlet UIButton* btnSurvey;


@property (retain, nonatomic) NSString* DeptCode;
@property (retain, nonatomic) NSString* DeptName;

-(IBAction)hideSelection:(id)sender;
@end
