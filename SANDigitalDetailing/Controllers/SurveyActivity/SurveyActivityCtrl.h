//
//  SurveyActivityCtrl.h
//  SANDigitalDetailing
//
//  Created by Mac on 25/04/21.
//  Copyright © 2021 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "UserControls.h"

NS_ASSUME_NONNULL_BEGIN

@interface SurveyActivityCtrl : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UserControlDelegate>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) AppSetupData* SetupData;
@property (nonatomic, strong) CallMeetData* meetData;

@property (nonatomic, weak) IBOutlet UITableView* tbSurveyLst;
@property (nonatomic,retain) IBOutlet UIButton* btnFilter;
@property (nonatomic,retain) IBOutlet UIButton* btnSubmit;
@property (weak, nonatomic) IBOutlet UIButton *btnSelectHeadQtr;

@property (nonatomic,retain) IBOutlet UIScrollView* vwCtrlArea;
- (IBAction)btnSelectHdQtr:(id)sender;


@property (nonatomic,retain) IBOutlet UIView* vwCusList;
@property (nonatomic,retain) IBOutlet UIView* vwCusSel;

@property (nonatomic, weak) IBOutlet UIView* vwAdCtrl;
@property (nonatomic, retain) IBOutlet UIView* vwCtrlsView;

@property (nonatomic,retain) IBOutlet UITextField* txtSelCus;
@property (nonatomic,weak) IBOutlet UILabel* lblSrvyNm;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;
@property (weak, nonatomic) IBOutlet UISearchBar *txtfldSearchBar;

@end

NS_ASSUME_NONNULL_END
