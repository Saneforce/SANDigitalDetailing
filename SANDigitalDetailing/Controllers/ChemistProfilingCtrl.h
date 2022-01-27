//
//  ChemistProfilingCtrl.h
//  SANDigitalDetailing
//
//  Created by SANeForce.com on 20/01/19.
//  Copyright © 2019 SANeForce.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "ChmProfileData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChemistProfilingCtrl :
UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UserDetails* UserDet;
@property (nonatomic, strong) CallMeetData* meetData;
@property (nonatomic, strong) ChmProfileData* ChmProfData;

@property (nonatomic,strong) NSArray *objHQList;
@property (weak, nonatomic) IBOutlet UIView *vwSelBxModal;

@property (nonatomic, weak) IBOutlet UIView* selChmView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint* nsScrollHeight;

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;
@property (nonatomic, weak) IBOutlet UICollectionViewFlowLayout* layout;

@property (nonatomic, weak) IBOutlet UIButton* btnBack;
@property (nonatomic,weak) IBOutlet UITableView *tbHQ;
@property (nonatomic, weak) IBOutlet UITableView *tbSelectBx;

@property (nonatomic, weak) IBOutlet UITextField* searchBox;
@property (weak, nonatomic) IBOutlet UILabel *lblChmName;
@property (weak, nonatomic) IBOutlet UILabel *lblTittle;

@property (weak, nonatomic) IBOutlet UIButton *btnCate;
@property (weak, nonatomic) IBOutlet UIButton *btnTerr;
@property (nonatomic,weak) IBOutlet UIButton *btnSelHQ;
@property (nonatomic,weak) IBOutlet UIButton *btnSelectbx;

@property (nonatomic, weak) IBOutlet UIView *vwSelectbx;


@property (nonatomic, weak) IBOutlet UITextField* txtCnctPNm;
@property (nonatomic, weak) IBOutlet UITextField* txtAdd1;
@property (nonatomic, weak) IBOutlet UITextField* txtCity;
@property (nonatomic, weak) IBOutlet UITextField* txtMob;
@property (nonatomic, weak) IBOutlet UITextField* txtPhone;
@property (nonatomic, weak) IBOutlet UITextField* txtEmail;

@property (weak, nonatomic) NSString* CustCode;

-(IBAction)showCutomerList:(id)sender;
-(IBAction)searchDoctor:(id)sender;

@end

NS_ASSUME_NONNULL_END
